import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/services/pref_service.dart';

part 'verse_settings_provider.g.dart';

enum PlaybackMode {
  slokaOnly,
  translationOnly,
  both,
}

class VerseSettings {
  const VerseSettings({
    this.selectedLanguage = 'english',
    this.selectedTranslatorId,
    this.selectedCommentatorId,
    this.selectedAudioVoice = 'male',
    this.playbackMode = PlaybackMode.both,
  });

  final String selectedLanguage;
  final int? selectedTranslatorId;
  final int? selectedCommentatorId;
  final String selectedAudioVoice;
  final PlaybackMode playbackMode;

  VerseSettings copyWith({
    String? selectedLanguage,
    int? selectedTranslatorId,
    int? selectedCommentatorId,
    String? selectedAudioVoice,
    PlaybackMode? playbackMode,
  }) {
    return VerseSettings(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedTranslatorId: selectedTranslatorId ?? this.selectedTranslatorId,
      selectedCommentatorId: selectedCommentatorId ?? this.selectedCommentatorId,
      selectedAudioVoice: selectedAudioVoice ?? this.selectedAudioVoice,
      playbackMode: playbackMode ?? this.playbackMode,
    );
  }
}

@riverpod
class VerseSettingsNotifier extends _$VerseSettingsNotifier {
  @override
  VerseSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final playbackModeStr = prefs.getString('pref_verse_playback_mode') ?? 'both';
    final playbackMode = PlaybackMode.values.firstWhere(
      (e) => e.name == playbackModeStr,
      orElse: () => PlaybackMode.both,
    );

    return VerseSettings(
      selectedLanguage: prefs.getString('pref_verse_language') ?? 'english',
      selectedTranslatorId: prefs.getInt('pref_verse_translator_id'),
      selectedCommentatorId: prefs.getInt('pref_verse_commentator_id'),
      selectedAudioVoice: prefs.getString('pref_verse_audio_voice') ?? 'male',
      playbackMode: playbackMode,
    );
  }

  void setLanguage(String language) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('pref_verse_language', language);
    prefs.remove('pref_verse_translator_id');
    prefs.remove('pref_verse_commentator_id');
    
    // When language changes, clear translator and commentator IDs 
    // because they might not exist in the new language
    state = state.copyWith(
      selectedLanguage: language,
      selectedTranslatorId: null,
      selectedCommentatorId: null,
    );
  }

  void setTranslator(int translatorId) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt('pref_verse_translator_id', translatorId);
    state = state.copyWith(selectedTranslatorId: translatorId);
  }

  void setCommentator(int commentatorId) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt('pref_verse_commentator_id', commentatorId);
    state = state.copyWith(selectedCommentatorId: commentatorId);
  }

  void setAudioVoice(String voice) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('pref_verse_audio_voice', voice);
    state = state.copyWith(selectedAudioVoice: voice);
  }

  void setPlaybackMode(PlaybackMode mode) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('pref_verse_playback_mode', mode.name);
    state = state.copyWith(playbackMode: mode);
  }
}
