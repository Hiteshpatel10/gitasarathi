import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/services/pref_service.dart';

part 'verse_settings_provider.g.dart';

class VerseSettings {
  const VerseSettings({
    this.selectedLanguage = 'english',
    this.selectedTranslatorId,
    this.selectedCommentatorId,
    this.selectedAudioVoice = 'male',
  });

  final String selectedLanguage;
  final int? selectedTranslatorId;
  final int? selectedCommentatorId;
  final String selectedAudioVoice;

  VerseSettings copyWith({
    String? selectedLanguage,
    int? selectedTranslatorId,
    int? selectedCommentatorId,
    String? selectedAudioVoice,
  }) {
    return VerseSettings(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedTranslatorId: selectedTranslatorId ?? this.selectedTranslatorId,
      selectedCommentatorId: selectedCommentatorId ?? this.selectedCommentatorId,
      selectedAudioVoice: selectedAudioVoice ?? this.selectedAudioVoice,
    );
  }
}

@riverpod
class VerseSettingsNotifier extends _$VerseSettingsNotifier {
  @override
  VerseSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return VerseSettings(
      selectedLanguage: prefs.getString('pref_verse_language') ?? 'english',
      selectedTranslatorId: prefs.getInt('pref_verse_translator_id'),
      selectedCommentatorId: prefs.getInt('pref_verse_commentator_id'),
      selectedAudioVoice: prefs.getString('pref_verse_audio_voice') ?? 'male',
    );
  }

  void setLanguage(String language) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('pref_verse_language', language);
    prefs.remove('pref_verse_translator_id');
    prefs.remove('pref_verse_commentator_id');
    
    // When language changes, clear translator and commentator IDs 
    // because they might not exist in the new language
    state = VerseSettings(selectedLanguage: language);
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
}
