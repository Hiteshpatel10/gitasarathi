import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app/features/chapters/model/verse_models.dart';
import 'package:app/features/chapters/model/chapter_models.dart';
import 'package:app/features/chapters/provider/verse_settings_provider.dart';
import 'package:app/features/chapters/provider/chapters_providers.dart';

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

@riverpod
class GlobalAudioNotifier extends _$GlobalAudioNotifier {
  late AudioPlayer _player;

  @override
  GlobalAudioState build() {
    _player = AudioPlayer();

    ref.onDispose(() {
      _player.dispose();
    });

    _player.onPlayerStateChanged.listen((state) {
      this.state = this.state.copyWith(isPlaying: state == PlayerState.playing);
    });

    _player.onDurationChanged.listen((newDuration) {
      this.state = this.state.copyWith(duration: newDuration);
    });

    _player.onPositionChanged.listen((newPosition) {
      this.state = this.state.copyWith(position: newPosition);
    });

    _player.onPlayerComplete.listen((event) {
      _handlePhaseComplete();
    });

    // Re-play if voice changes during active playback
    ref.listen(verseSettingsProvider.select((s) => s.selectedAudioVoice), (prev, next) {
      if (state.isPlaying && state.currentPhase == AudioPhase.mool) {
        _playCurrentPhase();
      }
    });
    
    // Re-play if language changes during translation playback
    ref.listen(verseSettingsProvider.select((s) => s.selectedLanguage), (prev, next) {
      if (state.isPlaying && state.currentPhase == AudioPhase.translation) {
        _playCurrentPhase();
      }
    });

    Future.microtask(() {
      if (state.currentVerse == null) {
        _initInitialState();
      }
    });

    return const GlobalAudioState();
  }

  Future<void> _initInitialState() async {
    try {
      final chapters = await ref.read(chaptersListProvider.future);
      if (chapters != null && chapters.isNotEmpty) {
        final chapter1 = chapters.firstWhere((c) => c.chapterNumber == 1, orElse: () => chapters.first);
        final verses = await ref.read(chapterVersesProvider(chapter1.chapterNumber).future);
        if (verses != null && verses.isNotEmpty) {
          final verse1Meta = verses.firstWhere((v) => v.verseNumber == 1, orElse: () => verses.first);
          final verse1 = await ref.read(verseExplanationProvider(verse1Meta.id).future);
          if (verse1 != null) {
            state = state.copyWith(
              currentVerse: verse1,
              currentChapter: chapter1,
            );
          }
        }
      }
    } catch (e) {
      // Ignore initial load errors
    }
  }

  void toggleAutoAdvance() {
    state = state.copyWith(autoAdvance: !state.autoAdvance);
  }

  Future<void> playVerse(VerseDetails verse, Chapter chapter) async {
    state = state.copyWith(
      currentVerse: verse,
      currentChapter: chapter,
      currentPhase: AudioPhase.mool,
      position: Duration.zero,
    );
    await _playCurrentPhase();
  }

  Future<void> setSpeed(double speed) async {
    await _player.setPlaybackRate(speed);
    state = state.copyWith(playbackSpeed: speed);
  }

  Future<void> togglePlayPause() async {
    if (state.currentVerse == null) return;
    
    if (state.isPlaying) {
      await _player.pause();
    } else {
      if (state.position >= state.duration && state.duration > Duration.zero) {
        state = state.copyWith(currentPhase: AudioPhase.mool);
      }
      await _playCurrentPhase();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> playNextVerse() async {
    if (state.currentVerse == null || state.currentChapter == null) return;
    
    state = state.copyWith(isLoadingNext: true);
    
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.chapterNumber).future);
      if (verses == null || verses.isEmpty) return;
      
      final currentIndex = verses.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);
      if (currentIndex != -1 && currentIndex < verses.length - 1) {
        final nextVerseMetadata = verses[currentIndex + 1];
        final nextVerse = await ref.read(verseExplanationProvider(nextVerseMetadata.id).future);
        if (nextVerse != null) {
          await playVerse(nextVerse, state.currentChapter!);
        }
      }
    } finally {
      state = state.copyWith(isLoadingNext: false);
    }
  }

  Future<void> playPreviousVerse() async {
    if (state.currentVerse == null || state.currentChapter == null) return;
    
    state = state.copyWith(isLoadingNext: true);
    
    try {
      final verses = await ref.read(chapterVersesProvider(state.currentChapter!.chapterNumber).future);
      if (verses == null || verses.isEmpty) return;
      
      final currentIndex = verses.indexWhere((v) => v.verseNumber == state.currentVerse!.verseNumber);
      if (currentIndex > 0) {
        final prevVerseMetadata = verses[currentIndex - 1];
        final prevVerse = await ref.read(verseExplanationProvider(prevVerseMetadata.id).future);
        if (prevVerse != null) {
          await playVerse(prevVerse, state.currentChapter!);
        }
      }
    } finally {
      state = state.copyWith(isLoadingNext: false);
    }
  }

  Future<void> _handlePhaseComplete() async {
    if (state.currentPhase == AudioPhase.mool) {
      state = state.copyWith(currentPhase: AudioPhase.translation);
      await _playCurrentPhase();
    } else {
      state = state.copyWith(
        currentPhase: AudioPhase.mool,
        position: Duration.zero,
        isPlaying: false,
      );
      if (state.autoAdvance) {
        await playNextVerse();
      }
    }
  }

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

  Future<void> _playCurrentPhase() async {
    final url = _getUrlForPhase(state.currentPhase);
    if (url != null && url.isNotEmpty) {
      await _player.play(UrlSource(url));
      await _player.setPlaybackRate(state.playbackSpeed);
    } else if (state.currentPhase == AudioPhase.mool) {
      // If no mool track, fallback skip?
      _handlePhaseComplete();
    }
  }
}
