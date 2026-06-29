import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app/features/chapters/model/verse_models.dart';
import 'package:app/features/chapters/model/chapter_models.dart';
import 'package:app/features/chapters/provider/verse_settings_provider.dart';
import 'package:app/features/chapters/provider/chapters_providers.dart';
import 'package:app/core/services/audio_cache_service.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';

part 'global_audio_provider.g.dart';

enum AudioPhase { mool, translation }

class GlobalAudioState {
  const GlobalAudioState({
    this.isPlaying = false,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.currentPhase = AudioPhase.mool,
    this.currentVerse,
    this.currentChapter,
    this.playbackSpeed = 1.0,
    this.autoAdvance = true,
    this.isLoadingNext = false,
    this.isInitializing = true,
  });

  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final AudioPhase currentPhase;
  final VerseDetails? currentVerse;
  final Chapter? currentChapter;
  final double playbackSpeed;
  final bool autoAdvance;
  final bool isLoadingNext;
  final bool isInitializing;

  GlobalAudioState copyWith({
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    AudioPhase? currentPhase,
    VerseDetails? currentVerse,
    Chapter? currentChapter,
    double? playbackSpeed,
    bool? autoAdvance,
    bool? isLoadingNext,
    bool? isInitializing,
  }) {
    return GlobalAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      currentPhase: currentPhase ?? this.currentPhase,
      currentVerse: currentVerse ?? this.currentVerse,
      currentChapter: currentChapter ?? this.currentChapter,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      isLoadingNext: isLoadingNext ?? this.isLoadingNext,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }
}

@Riverpod(keepAlive: true)
class GlobalAudioNotifier extends _$GlobalAudioNotifier {
  late AudioPlayer _player;
  final AudioCacheService _cache = AudioCacheService.instance;

  // Prevents concurrent phase-complete handlers
  bool _isAdvancing = false;

  @override
  GlobalAudioState build() {
    _player = AudioPlayer();

    ref.onDispose(() {
      _player.dispose();
    });

    _player.onPlayerStateChanged.listen((pState) {
      state = state.copyWith(isPlaying: pState == PlayerState.playing);
    });

    _player.onDurationChanged.listen((d) {
      state = state.copyWith(duration: d);
    });

    _player.onPositionChanged.listen((p) {
      state = state.copyWith(position: p);
    });

    _player.onPlayerComplete.listen((_) {
      _handlePhaseComplete();
    });

    // Re-play if voice changes mid-playback on mool phase
    ref.listen(verseSettingsProvider.select((s) => s.selectedAudioVoice), (prev, next) {
      if (prev != next) {
        if (state.isPlaying && state.currentPhase == AudioPhase.mool) {
          _playCurrentPhase();
        } else {
          _prefetchNextPhase();
        }
      }
    });

    // Re-play if language changes mid-playback on translation phase
    ref.listen(verseSettingsProvider.select((s) => s.selectedLanguage), (prev, next) {
      if (prev != next) {
        if (state.isPlaying && state.currentPhase == AudioPhase.translation) {
          _playCurrentPhase();
        } else {
          _prefetchNextPhase();
        }
      }
    });

    Future.microtask(() {
      if (state.isInitializing) _initInitialState();
    });

    return const GlobalAudioState();
  }

  // ─── Init ─────────────────────────────────────────────────────────────────

  Future<void> _initInitialState() async {
    try {
      final allVerses = await ref.read(allVersesProvider.future);
      if (allVerses.isEmpty) {
        state = state.copyWith(isInitializing: false);
        return;
      }

      final prefs = ref.read(prefServiceProvider);
      final lastVerseId = prefs.getInt(PrefKeys.lastPlayedVerseId);

      final targetIdx = allVerses.indexWhere((v) => v.id == lastVerseId);
      final targetMeta = targetIdx != -1 ? allVerses[targetIdx] : allVerses.first;

      final verse = await ref.read(verseExplanationProvider(targetMeta.id).future);
      if (verse == null) {
        state = state.copyWith(isInitializing: false);
        return;
      }

      final chapters = await ref.read(chaptersListProvider.future);
      if (chapters == null) {
        state = state.copyWith(isInitializing: false);
        return;
      }
      final chapter = chapters.firstWhere(
        (c) => c.id == targetMeta.chapterId,
        orElse: () => chapters.first,
      );

      // Prevent overwriting if user already started playing a verse
      if (!state.isInitializing) return;

      state = state.copyWith(currentVerse: verse, currentChapter: chapter, isInitializing: false);
      // Warm up cache for first verse in background
      _prefetchCurrentPhase();
    } catch (_) {
      state = state.copyWith(isInitializing: false);
    }
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  void toggleAutoAdvance() {
    state = state.copyWith(autoAdvance: !state.autoAdvance);
    if (state.autoAdvance) _prefetchNextPhase();
  }

  Future<void> playVerse(VerseDetails verse, Chapter chapter) async {
    _isAdvancing = false;   // reset lock when manually selecting a verse
    
    ref.read(prefServiceProvider).setInt(PrefKeys.lastPlayedVerseId, verse.id);
    
    state = state.copyWith(
      currentVerse: verse,
      currentChapter: chapter,
      currentPhase: AudioPhase.mool,
      position: Duration.zero,
      duration: Duration.zero,
      isInitializing: false,
    );
    await _playCurrentPhase();
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(playbackSpeed: speed);
    await _player.setPlaybackRate(speed);
  }

  Future<void> togglePlayPause() async {
    if (state.currentVerse == null) return;

    if (state.isPlaying) {
      await _player.pause();
    } else {
      // If track finished or never started, restart from mool
      if (state.duration == Duration.zero ||
          (state.position >= state.duration && state.duration > Duration.zero)) {
        state = state.copyWith(currentPhase: AudioPhase.mool, position: Duration.zero, duration: Duration.zero);
        await _playCurrentPhase();
      } else {
        await _player.resume();
      }
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> playNextVerse() async {
    final next = await _getAdjacentVerse(1);
    if (next != null) await playVerse(next.$1, next.$2);
  }

  Future<void> playPreviousVerse() async {
    state = state.copyWith(isLoadingNext: true);
    try {
      final prev = await _getAdjacentVerse(-1);
      if (prev != null) await playVerse(prev.$1, prev.$2);
    } finally {
      state = state.copyWith(isLoadingNext: false);
    }
  }


  // ─── Phase Advancement ────────────────────────────────────────────────────

  Future<void> _handlePhaseComplete() async {
    if (_isAdvancing) return;
    _isAdvancing = true;

    // Determine next action synchronously, then release the lock BEFORE
    // any async playback call. This prevents a re-entrant deadlock where
    // _playCurrentPhase's error handler calls _handlePhaseComplete() but
    // finds _isAdvancing=true and silently returns.
    try {
      if (state.currentPhase == AudioPhase.mool) {
        final translationUrl = _getUrlForPhase(AudioPhase.translation);
        if (translationUrl != null && translationUrl.isNotEmpty) {
          state = state.copyWith(
            currentPhase: AudioPhase.translation,
            position: Duration.zero,
            duration: Duration.zero,
          );
          _isAdvancing = false; // Release before async playback
          await _playCurrentPhase();
        } else {
          _isAdvancing = false;
          if (state.autoAdvance) {
            await _advanceToNextVerse();
          } else {
            _resetStopped();
          }
        }
      } else {
        // Translation phase done — go to next verse
        _isAdvancing = false;
        if (state.autoAdvance) {
          await _advanceToNextVerse();
        } else {
          _resetStopped();
        }
      }
    } catch (_) {
      _isAdvancing = false;
    }
  }

  Future<void> _advanceToNextVerse() async {
    final next = await _getAdjacentVerse(1);
    if (next != null) {
      ref.read(prefServiceProvider).setInt(PrefKeys.lastPlayedVerseId, next.$1.id);
      
      state = state.copyWith(
        currentVerse: next.$1,
        currentChapter: next.$2,
        currentPhase: AudioPhase.mool,
        position: Duration.zero,
        duration: Duration.zero,
      );
      await _playCurrentPhase();
    } else {
      // End of all chapters
      _resetStopped();
    }
  }

  void _resetStopped() {
    state = state.copyWith(
      currentPhase: AudioPhase.mool,
      position: Duration.zero,
      isPlaying: false,
    );
  }

  // ─── Playback Core ────────────────────────────────────────────────────────

  Future<void> _playCurrentPhase() async {
    final url = _getUrlForPhase(state.currentPhase);
    if (url == null || url.isEmpty) {
      // Skip this phase (e.g. missing translation URL)
      _handlePhaseComplete();
      return;
    }

    try {
      // Download to cache if needed, then play from local file
      final localPath = await _cache.getLocalPath(url);
      if (localPath != null) {
        await _player.play(DeviceFileSource(localPath));
      } else {
        // Fallback: stream directly from URL if download failed
        await _player.play(UrlSource(url));
      }
      await _player.setPlaybackRate(state.playbackSpeed);

      // Prefetch the next phase in the background
      _prefetchNextPhase();
    } catch (_) {
      // Playback failed (network error, 403, codec issue, etc.).
      // Advance the queue so the next track / phase plays instead of stopping.
      await _handlePhaseComplete();
    }
  }

  /// Prefetches current phase URL to warm the cache (used on initial load).
  void _prefetchCurrentPhase() {
    final url = _getUrlForPhase(state.currentPhase);
    _cache.prefetch(url);
  }

  /// Prefetches the next audio file to local cache in the background.
  void _prefetchNextPhase() {
    if (state.currentPhase == AudioPhase.mool) {
      _cache.prefetch(_getUrlForPhase(AudioPhase.translation));
    } else if (state.autoAdvance) {
      // Prefetch next verse's mool — best-effort (we don't have it yet, so async)
      _prefetchNextVerseMool();
    }
  }

  Future<void> _prefetchNextVerseMool() async {
    try {
      final next = await _getAdjacentVerse(1);
      if (next == null) return;
      final settings = ref.read(verseSettingsProvider);
      final isMale = settings.selectedAudioVoice == 'male';
      final url = isMale ? next.$1.audioLinks?.moolMale : next.$1.audioLinks?.moolFemale;
      _cache.prefetch(url);
    } catch (_) {}
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String? _getUrlForPhase(AudioPhase phase) {
    final settings = ref.read(verseSettingsProvider);
    final isMale = settings.selectedAudioVoice == 'male';
    final isHindi = settings.selectedLanguage.toLowerCase() == 'hindi';

    final audioLinks = state.currentVerse?.audioLinks;
    if (audioLinks == null) return null;

    if (phase == AudioPhase.mool) {
      return isMale ? audioLinks.moolMale : audioLinks.moolFemale;
    } else {
      return isHindi
          ? audioLinks.hindiFemaleTranslation
          : audioLinks.englishFemaleTranslation;
    }
  }

  /// Returns the (verse, chapter) adjacent to the current one.
  /// Uses a flat globally-sorted verse list — just idx ± 1, no chapter-boundary logic needed.
  /// [direction]: 1 = next, -1 = previous.
  Future<(VerseDetails, Chapter)?> _getAdjacentVerse(int direction) async {
    if (state.currentVerse == null) return null;
    try {
      final allVerses = await ref.read(allVersesProvider.future);
      if (allVerses.isEmpty) return null;

      final idx = allVerses.indexWhere((v) => v.id == state.currentVerse!.id);
      if (idx == -1) return null;

      final targetIdx = idx + direction;
      if (targetIdx < 0 || targetIdx >= allVerses.length) return null;

      final targetMeta = allVerses[targetIdx];
      final verse = await ref.read(verseExplanationProvider(targetMeta.id).future);
      if (verse == null) return null;

      // Find the Chapter object for the target verse (from cached list)
      final chapters = await ref.read(chaptersListProvider.future);
      if (chapters == null) return null;
      final chapter = chapters.firstWhere(
        (c) => c.id == targetMeta.chapterId,
        orElse: () => chapters.first,
      );

      return (verse, chapter);
    } catch (_) {}
    return null;
  }
}
