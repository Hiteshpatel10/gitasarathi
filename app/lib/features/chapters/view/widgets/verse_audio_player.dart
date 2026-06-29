import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app/features/chapters/model/verse_models.dart';
import 'package:app/features/chapters/provider/verse_settings_provider.dart';
import 'package:app/core/theme/app_colors.dart';

enum AudioPhase { mool, translation }

class VerseAudioPlayer extends ConsumerStatefulWidget {
  const VerseAudioPlayer({
    super.key,
    required this.audioLinks,
  });

  final AudioLinks? audioLinks;

  @override
  ConsumerState<VerseAudioPlayer> createState() => _VerseAudioPlayerState();
}

class _VerseAudioPlayerState extends ConsumerState<VerseAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  AudioPhase _currentPhase = AudioPhase.mool;

  @override
  void initState() {
    super.initState();

    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _player.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _player.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _player.onPlayerComplete.listen((event) {
      _handlePhaseComplete();
    });
  }

  void _handlePhaseComplete() {
    if (_currentPhase == AudioPhase.mool) {
      setState(() {
        _currentPhase = AudioPhase.translation;
      });
      _playCurrentPhase();
    } else {
      // Finished both
      setState(() {
        _currentPhase = AudioPhase.mool;
        _position = Duration.zero;
        _isPlaying = false;
      });
    }
  }

  String? _getUrlForPhase(AudioPhase phase) {
    final settings = ref.read(verseSettingsProvider);
    final isMale = settings.selectedAudioVoice == 'male';
    final isHindi = settings.selectedLanguage.toLowerCase() == 'hindi';

    if (widget.audioLinks == null) return null;

    if (phase == AudioPhase.mool) {
      return isMale ? widget.audioLinks!.moolMale : widget.audioLinks!.moolFemale;
    } else {
      // Translation phase
      return isHindi 
          ? widget.audioLinks!.hindiFemaleTranslation 
          : widget.audioLinks!.englishFemaleTranslation;
    }
  }

  Future<void> _playCurrentPhase() async {
    final url = _getUrlForPhase(_currentPhase);
    if (url != null && url.isNotEmpty) {
      await _player.play(UrlSource(url));
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      // If we are at the end, restart
      if (_position >= _duration && _duration > Duration.zero) {
        _currentPhase = AudioPhase.mool;
      }
      await _playCurrentPhase();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioLinks == null) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final settings = ref.watch(verseSettingsProvider);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.tertiarySystemBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.label.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentPhase == AudioPhase.mool ? 'MOOL SLOKA' : 'TRANSLATION',
                style: TextStyle(
                  color: Colors.orange.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final newVoice = settings.selectedAudioVoice == 'male' ? 'female' : 'male';
                  ref.read(verseSettingsProvider.notifier).setAudioVoice(newVoice);
                  if (_isPlaying && _currentPhase == AudioPhase.mool) {
                     _playCurrentPhase();
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      settings.selectedAudioVoice == 'male' ? Icons.face : Icons.face_3,
                      color: colors.secondaryLabel,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      settings.selectedAudioVoice.toUpperCase(),
                      style: TextStyle(
                        color: colors.secondaryLabel,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.orange,
                  size: 44,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: Colors.orange,
                        inactiveTrackColor: colors.label.withValues(alpha: 0.1),
                        thumbColor: Colors.orange,
                        overlayColor: Colors.orange.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0),
                        min: 0.0,
                        max: _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                        onChanged: (val) {
                          _player.seek(Duration(milliseconds: val.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(color: colors.secondaryLabel, fontSize: 10),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(color: colors.secondaryLabel, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
