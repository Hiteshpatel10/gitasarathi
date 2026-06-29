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
    final next = await _getNextVerseAndChapter();
    if (next != null) {
      await playVerse(next.$1, next.$2);
    }
  }

  Future<void> playPreviousVerse() async {
    if (state.currentVerse == null || state.currentChapter == null) return;
    state = state.copyWith(isLoadingNext: true);
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.id).future);
      if (verses == null || verses.isEmpty) return;

      // Sort ascending so index math always goes in the right direction
      final sorted = [...verses]..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
      final currentIndex = sorted.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);

      if (currentIndex > 0) {
        // Previous verse in the same chapter
        final prevMeta = sorted[currentIndex - 1];
        final prevVerse = await ref.read(verseExplanationProvider(prevMeta.id).future);
        if (prevVerse != null) await playVerse(prevVerse, state.currentChapter!);
      } else if (currentIndex == 0) {
        // First verse of this chapter — go to last verse of previous chapter
        final chapters = await ref.read(chaptersListProvider.future);
        if (chapters == null || chapters.isEmpty) return;

        final sortedChapters = [...chapters]..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
        final chapterIdx = sortedChapters.indexWhere((c) => c.id == state.currentChapter!.id);
        if (chapterIdx > 0) {
          final prevChapter = sortedChapters[chapterIdx - 1];
          final prevChapterVerses = await ref.read(chapterVersesProvider(prevChapter.id).future);
          if (prevChapterVerses == null || prevChapterVerses.isEmpty) return;

          final sortedPrevVerses = [...prevChapterVerses]..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
          final lastVerseMeta = sortedPrevVerses.last;
          final lastVerse = await ref.read(verseExplanationProvider(lastVerseMeta.id).future);
          if (lastVerse != null) await playVerse(lastVerse, prevChapter);
        }
      }
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
    final next = await _getNextVerseAndChapter();
    if (next != null) {
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
      final next = await _getNextVerseAndChapter();
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

  /// Returns the next (verse, chapter) pair across chapter boundaries.
  /// Returns null only at the very end of the last chapter.
  Future<(VerseDetails, Chapter)?> _getNextVerseAndChapter() async {
    if (state.currentVerse == null || state.currentChapter == null) return null;
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.id).future);
      if (verses == null) return null;

      // Sort ascending so idx+1 is always the next verse in order
      final sorted = [...verses]..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
      final idx = sorted.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);

      if (idx != -1 && idx < sorted.length - 1) {
        // Next verse in the same chapter
        final nextMeta = sorted[idx + 1];
        final nextVerse = await ref.read(verseExplanationProvider(nextMeta.id).future);
        if (nextVerse != null) return (nextVerse, state.currentChapter!);
      } else if (idx == sorted.length - 1) {
        // Last verse of this chapter — try to move to next chapter
        final chapters = await ref.read(chaptersListProvider.future);
        if (chapters == null || chapters.isEmpty) return null;

        final sortedChapters = [...chapters]..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
        final chapterIdx = sortedChapters.indexWhere((c) => c.id == state.currentChapter!.id);
        if (chapterIdx != -1 && chapterIdx < sortedChapters.length - 1) {
          final nextChapter = sortedChapters[chapterIdx + 1];
          final nextChapterVerses = await ref.read(chapterVersesProvider(nextChapter.id).future);
          if (nextChapterVerses == null || nextChapterVerses.isEmpty) return null;

          final sortedNextVerses = [...nextChapterVerses]..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
          final firstVerseMeta = sortedNextVerses.first;
          final firstVerse = await ref.read(verseExplanationProvider(firstVerseMeta.id).future);
          if (firstVerse != null) return (firstVerse, nextChapter);
        }
      }
    } catch (_) {}
    return null;
  }
}
