import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/providers/global_audio_provider.dart';
import 'package:app/features/chapters/provider/verse_settings_provider.dart';
import 'package:app/features/chapters/model/verse_models.dart';

class ListenScreen extends ConsumerWidget {
  const ListenScreen({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final audioState = ref.watch(globalAudioProvider);
    final audioNotifier = ref.read(globalAudioProvider.notifier);
    final verseSettings = ref.watch(verseSettingsProvider);

    if (audioState.isInitializing) {
      return Scaffold(
        backgroundColor: colors.systemBackground,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (audioState.currentVerse == null || audioState.currentChapter == null) {
      return Scaffold(
        backgroundColor: colors.systemBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_note, size: 64, color: colors.secondaryLabel),
              const SizedBox(height: 16),
              Text(
                'No verse playing',
                style: TextStyle(color: colors.label, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a verse from a chapter to start listening',
                style: TextStyle(color: colors.secondaryLabel, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final verse = audioState.currentVerse!;
    final chapter = audioState.currentChapter!;
    final isMale = verseSettings.selectedAudioVoice == 'male';

    return Scaffold(
      backgroundColor: colors.systemBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: colors.label, size: 32),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed('home');
            }
          },
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(color: colors.label, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              audioState.autoAdvance ? Icons.autorenew : Icons.autorenew_outlined,
              color: audioState.autoAdvance ? colors.saffron : colors.secondaryLabel,
            ),
            tooltip: 'Auto-advance',
            onPressed: () {
              audioNotifier.toggleAutoAdvance();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(audioState.autoAdvance ? 'Auto-advance disabled' : 'Auto-advance enabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.tune, color: colors.label),
            tooltip: 'Playback Settings',
            onPressed: () => _showPlaybackSettings(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      // Album Art
                      Hero(
                        tag: 'audio_album_art',
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colors.saffron.withValues(alpha: 0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(chapter.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Text Area
                      Column(
                        children: [
                          Text(
                            'Chapter ${chapter.chapterNumber} • Verse ${verse.verseNumber}',
                            style: TextStyle(
                              color: colors.saffron,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            verse.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.label,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              fontFamily: 'Serif',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getTranslationPreview(verse, verseSettings),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.secondaryLabel,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Bottom Section (Progress Bar + Controls)
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 24.0),
              decoration: BoxDecoration(
                color: colors.systemBackground,
                boxShadow: [
                  BoxShadow(
                    color: colors.label.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress Bar
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: colors.saffron,
                      inactiveTrackColor: colors.label.withValues(alpha: 0.1),
                      thumbColor: colors.saffron,
                      overlayColor: colors.saffron.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: audioState.position.inMilliseconds.toDouble().clamp(0, audioState.duration.inMilliseconds.toDouble() > 0 ? audioState.duration.inMilliseconds.toDouble() : 1.0),
                      min: 0.0,
                      max: audioState.duration.inMilliseconds.toDouble() > 0 ? audioState.duration.inMilliseconds.toDouble() : 1.0,
                      onChanged: (val) {
                        audioNotifier.seek(Duration(milliseconds: val.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(audioState.position),
                          style: TextStyle(color: colors.secondaryLabel, fontSize: 12),
                        ),
                        Text(
                          _formatDuration(audioState.duration),
                          style: TextStyle(color: colors.secondaryLabel, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phase indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.secondarySystemBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.label.withValues(alpha: 0.05)),
                    ),
                    child: Text(
                      audioState.currentPhase == AudioPhase.mool ? 'MOOL SLOKA' : 'TRANSLATION',
                      style: TextStyle(
                        color: colors.saffron,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Speed
                      GestureDetector(
                        onTap: () {
                          final currentSpeed = audioState.playbackSpeed;
                          double newSpeed = 1.0;
                          if (currentSpeed == 1.0) {
                            newSpeed = 1.25;
                          } else if (currentSpeed == 1.25) {
                            newSpeed = 1.5;
                          } else if (currentSpeed == 1.5) {
                            newSpeed = 2.0;
                          } else if (currentSpeed == 2.0) {
                            newSpeed = 0.75;
                          }
                          
                          audioNotifier.setSpeed(newSpeed);
                        },
                        child: Text(
                          '${audioState.playbackSpeed}x',
                          style: TextStyle(color: colors.label, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      
                      // Previous
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: colors.label, size: 36),
                        onPressed: audioState.isLoadingNext ? null : () {
                          audioNotifier.playPreviousVerse();
                        },
                      ),
                      
                      // Play/Pause
                      GestureDetector(
                        onTap: () => audioNotifier.togglePlayPause(),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: colors.saffron,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.saffron.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: audioState.isLoadingNext
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : Icon(
                                  audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 36,
                                ),
                        ),
                      ),
                      
                      // Next
                      IconButton(
                        icon: Icon(Icons.skip_next, color: colors.label, size: 36),
                        onPressed: audioState.isLoadingNext ? null : () {
                          audioNotifier.playNextVerse();
                        },
                      ),

                      // Voice Toggle
                      GestureDetector(
                        onTap: () {
                          final newVoice = isMale ? 'female' : 'male';
                          ref.read(verseSettingsProvider.notifier).setAudioVoice(newVoice);
                        },
                        child: Icon(
                          isMale ? Icons.face : Icons.face_3,
                          color: colors.label,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTranslationPreview(VerseDetails verse, VerseSettings settings) {
    if (verse.translations.isEmpty) return 'No translation available';
    
    VerseTranslation? translation;
    if (settings.selectedTranslatorId != null) {
      try {
        translation = verse.translations.firstWhere((t) => t.authorId == settings.selectedTranslatorId);
      } catch (_) {}
    }
    
    if (translation == null) {
      try {
        translation = verse.translations.firstWhere((t) => t.lang.toLowerCase() == settings.selectedLanguage.toLowerCase());
      } catch (_) {}
    }
    
    translation ??= verse.translations.first;
    return translation.description;
  }

  void _showPlaybackSettings(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.secondarySystemBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final settings = ref.watch(verseSettingsProvider);
            final settingsNotifier = ref.read(verseSettingsProvider.notifier);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playback Settings',
                          style: TextStyle(
                            color: colors.label,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: colors.label),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Playback Mode Section
                    Text(
                      'PLAYBACK MODE',
                      style: TextStyle(
                        color: colors.secondaryLabel,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChoiceChip(
                          context,
                          label: 'Sloka & Translation',
                          selected: settings.playbackMode == PlaybackMode.both,
                          onSelected: (_) => settingsNotifier.setPlaybackMode(PlaybackMode.both),
                        ),
                        _buildChoiceChip(
                          context,
                          label: 'Sloka Only',
                          selected: settings.playbackMode == PlaybackMode.slokaOnly,
                          onSelected: (_) => settingsNotifier.setPlaybackMode(PlaybackMode.slokaOnly),
                        ),
                        _buildChoiceChip(
                          context,
                          label: 'Translation Only',
                          selected: settings.playbackMode == PlaybackMode.translationOnly,
                          onSelected: (_) => settingsNotifier.setPlaybackMode(PlaybackMode.translationOnly),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Language Section
                    Text(
                      'TRANSLATION LANGUAGE',
                      style: TextStyle(
                        color: colors.secondaryLabel,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChoiceChip(
                          context,
                          label: 'English',
                          selected: settings.selectedLanguage.toLowerCase() == 'english',
                          onSelected: (_) => settingsNotifier.setLanguage('english'),
                        ),
                        _buildChoiceChip(
                          context,
                          label: 'Hindi',
                          selected: settings.selectedLanguage.toLowerCase() == 'hindi',
                          onSelected: (_) => settingsNotifier.setLanguage('hindi'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sloka Voice Section
                    Text(
                      'SLOKA VOICE',
                      style: TextStyle(
                        color: colors.secondaryLabel,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChoiceChip(
                          context,
                          label: 'Male',
                          selected: settings.selectedAudioVoice == 'male',
                          onSelected: (_) => settingsNotifier.setAudioVoice('male'),
                        ),
                        _buildChoiceChip(
                          context,
                          label: 'Female',
                          selected: settings.selectedAudioVoice == 'female',
                          onSelected: (_) => settingsNotifier.setAudioVoice('female'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    final colors = context.colors;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : colors.label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: colors.saffron,
      backgroundColor: colors.secondarySystemBackground,
      side: BorderSide(
        color: selected ? colors.saffron : colors.label.withValues(alpha: 0.1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      showCheckmark: false,
    );
  }
}
