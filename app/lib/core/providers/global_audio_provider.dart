import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app/features/chapters/model/verse_models.dart';
import 'package:app/features/chapters/model/chapter_models.dart';
import 'package:app/features/chapters/provider/verse_settings_provider.dart';
import 'package:app/features/chapters/provider/chapters_providers.dart';
import 'package:app/core/services/audio_cache_service.dart';

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
      if (state.currentVerse == null) _initInitialState();
    });

    return const GlobalAudioState();
  }

  // ─── Init ─────────────────────────────────────────────────────────────────

  Future<void> _initInitialState() async {
    try {
      final chapters = await ref.read(chaptersListProvider.future);
      if (chapters == null || chapters.isEmpty) return;

      final chapter1 = chapters.firstWhere(
        (c) => c.chapterNumber == 1,
        orElse: () => chapters.first,
      );
      final verses = await ref.read(chapterVersesProvider(chapter1.id).future);
      if (verses == null || verses.isEmpty) return;

      final verse1Meta = verses.firstWhere(
        (v) => v.verseNumber == 1,
        orElse: () => verses.first,
      );
      final verse1 = await ref.read(verseExplanationProvider(verse1Meta.id).future);
      if (verse1 != null) {
        state = state.copyWith(currentVerse: verse1, currentChapter: chapter1);
        // Warm up cache for first verse in background
        _prefetchCurrentPhase();
      }
    } catch (_) {}
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  void toggleAutoAdvance() {
    state = state.copyWith(autoAdvance: !state.autoAdvance);
    if (state.autoAdvance) _prefetchNextPhase();
  }

  Future<void> playVerse(VerseDetails verse, Chapter chapter) async {
    _isAdvancing = false; // Reset lock when manually selecting a verse
    state = state.copyWith(
      currentVerse: verse,
      currentChapter: chapter,
      currentPhase: AudioPhase.mool,
      position: Duration.zero,
      duration: Duration.zero,
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
    final nextVerse = await _getNextVerse();
    if (nextVerse != null && state.currentChapter != null) {
      await playVerse(nextVerse, state.currentChapter!);
    }
  }

  Future<void> playPreviousVerse() async {
    if (state.currentVerse == null || state.currentChapter == null) return;
    state = state.copyWith(isLoadingNext: true);
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.id).future);
      if (verses == null || verses.isEmpty) return;

      final currentIndex = verses.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);
      if (currentIndex > 0) {
        final prevMeta = verses[currentIndex - 1];
        final prevVerse = await ref.read(verseExplanationProvider(prevMeta.id).future);
        if (prevVerse != null) await playVerse(prevVerse, state.currentChapter!);
      }
    } finally {
      state = state.copyWith(isLoadingNext: false);
    }
  }

  // ─── Phase Advancement ────────────────────────────────────────────────────

  Future<void> _handlePhaseComplete() async {
    if (_isAdvancing) return;
    _isAdvancing = true;

    try {
      if (state.currentPhase == AudioPhase.mool) {
        // Advance to translation
        final translationUrl = _getUrlForPhase(AudioPhase.translation);
        if (translationUrl != null && translationUrl.isNotEmpty) {
          state = state.copyWith(
            currentPhase: AudioPhase.translation,
            position: Duration.zero,
            duration: Duration.zero,
          );
          await _playCurrentPhase();
        } else {
          // No translation — if autoAdvance, go to next verse
          if (state.autoAdvance) {
            await _advanceToNextVerse();
          } else {
            _resetStopped();
          }
        }
      } else {
        // Translation done — advance to next verse if enabled
        if (state.autoAdvance) {
          await _advanceToNextVerse();
        } else {
          _resetStopped();
        }
      }
    } finally {
      _isAdvancing = false;
    }
  }

  Future<void> _advanceToNextVerse() async {
    final nextVerse = await _getNextVerse();
    if (nextVerse != null && state.currentChapter != null) {
      state = state.copyWith(
        currentVerse: nextVerse,
        currentPhase: AudioPhase.mool,
        position: Duration.zero,
        duration: Duration.zero,
      );
      await _playCurrentPhase();
    } else {
      // End of chapter
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
      final nextVerse = await _getNextVerse();
      if (nextVerse == null) return;
      final settings = ref.read(verseSettingsProvider);
      final isMale = settings.selectedAudioVoice == 'male';
      final url = isMale ? nextVerse.audioLinks?.moolMale : nextVerse.audioLinks?.moolFemale;
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

  Future<VerseDetails?> _getNextVerse() async {
    if (state.currentVerse == null || state.currentChapter == null) return null;
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.id).future);
      if (verses == null) return null;
      final idx = verses.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);
      if (idx != -1 && idx < verses.length - 1) {
        return await ref.read(verseExplanationProvider(verses[idx + 1].id).future);
      }
    } catch (_) {}
    return null;
  }
}
