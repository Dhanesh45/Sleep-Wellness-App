import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sleep_ui/story/models/story_template.dart';
import 'package:sleep_ui/story/models/voice_clone.dart';

class ConcentricRingsAnimation extends StatefulWidget {
  final bool isPlaying;
  final Widget child;

  const ConcentricRingsAnimation({
    super.key,
    required this.isPlaying,
    required this.child,
  });

  @override
  State<ConcentricRingsAnimation> createState() => _ConcentricRingsAnimationState();
}

class _ConcentricRingsAnimationState extends State<ConcentricRingsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ConcentricRingsAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ring 3 (outer, delayed)
            if (widget.isPlaying)
              _buildRing(
                1.0 + (_controller.value + 0.6) % 1.0,
                1.0 - ((_controller.value + 0.6) % 1.0),
              ),
            // Ring 2 (middle, delayed)
            if (widget.isPlaying)
              _buildRing(
                1.0 + (_controller.value + 0.3) % 1.0,
                1.0 - ((_controller.value + 0.3) % 1.0),
              ),
            // Ring 1 (inner)
            if (widget.isPlaying)
              _buildRing(
                1.0 + _controller.value,
                1.0 - _controller.value,
              ),
            // Avatar Child
            widget.child,
          ],
        );
      },
    );
  }

  Widget _buildRing(double scale, double opacity) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFFB923C).withValues(alpha: opacity * 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFB923C).withValues(alpha: opacity * 0.1),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class StoryAudioPlayerScreen extends StatefulWidget {
  final String storyid;
  final String voiceid;

  const StoryAudioPlayerScreen({
    super.key,
    required this.storyid,
    required this.voiceid,
  });

  @override
  State<StoryAudioPlayerScreen> createState() => _StoryAudioPlayerScreenState();
}

class _StoryAudioPlayerScreenState extends State<StoryAudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  StoryTemplate? _story;
  VoiceClone? _voice;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initDataAndPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getAudioUrl(String path) {
    if (path.startsWith('http')) return Uri.parse(path).toString();
    final rawUrl = Supabase.instance.client.storage.from('story-audios').getPublicUrl(path);
    return Uri.parse(rawUrl).toString();
  }

  Future<void> _initDataAndPlayer() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // 1. Fetch story details
      final storyData = await Supabase.instance.client
          .from('story_templates')
          .select('*')
          .eq('storyid', widget.storyid)
          .maybeSingle();

      if (storyData == null) {
        throw Exception('Story template not found');
      }
      _story = StoryTemplate.fromMap(storyData);

      // 2. Fetch selected voice details (skip if 'system' — not a valid UUID)
      if (widget.voiceid != 'system') {
        final voiceData = await Supabase.instance.client
            .from('voice_clones')
            .select('*')
            .eq('voiceid', widget.voiceid)
            .maybeSingle();

        if (voiceData != null) {
          _voice = VoiceClone.fromMap(voiceData);
        }
      }

      // 3. Fetch matching audio version
      var audioQuery = Supabase.instance.client
          .from('story_audio_versions')
          .select('audio_path')
          .eq('storyid', widget.storyid);

      if (widget.voiceid == 'system') {
        audioQuery = audioQuery.isFilter('voiceid', null);
      } else {
        audioQuery = audioQuery.eq('voiceid', widget.voiceid);
      }

      final audioData = await audioQuery.maybeSingle();

      if (audioData != null && audioData['audio_path'] != null) {
        _audioPath = audioData['audio_path'].toString();
      }

      // 4. Load audio in just_audio
      if (_audioPath != null) {
        // Use Uri.parse().toString() to normalize the URL safely without double-encoding
        final String fullUrl = _getAudioUrl(_audioPath!);
        debugPrint('Initializing player with remote URL: $fullUrl');
        await _audioPlayer.setUrl(fullUrl);
      } else {
        // Fallback to local asset audio for 'system' voice or missing audio path
        debugPrint('No remote audio found — falling back to local asset audio.');
        await _audioPlayer.setAsset('assets/sounds/rain.mp3');
      }

      // Start listening to state changes
      _audioPlayer.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            _position = pos;
          });
        }
      });

      _audioPlayer.durationStream.listen((dur) {
        if (mounted && dur != null) {
          setState(() {
            _duration = dur;
          });
        }
      });



      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            if (state.processingState == ProcessingState.completed) {
              _audioPlayer.seek(Duration.zero);
              _audioPlayer.pause();
            }
          });
        }
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _togglePlay() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }

  Future<void> _rewind10Seconds() async {
    final currentPos = _audioPlayer.position;
    final targetPos = currentPos - const Duration(seconds: 10);
    await _audioPlayer.seek(targetPos < Duration.zero ? Duration.zero : targetPos);
  }

  Future<void> _forward10Seconds() async {
    final currentPos = _audioPlayer.position;
    final targetPos = currentPos + const Duration(seconds: 10);
    final totalDur = _audioPlayer.duration ?? Duration.zero;
    await _audioPlayer.seek(targetPos > totalDur ? totalDur : targetPos);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    final String lang = _story?.language ?? 'en';

    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _hasError
                ? _buildErrorState(lang)
                : _buildPlayerContent(lang),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
      ),
    );
  }

  Widget _buildErrorState(String lang) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              LocalizedPlayer.getErrorLoading(lang),
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              style: GoogleFonts.quicksand(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initDataAndPlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB923C),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                LocalizedPlayer.getRetryButton(lang),
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerContent(String lang) {
    final String title = _story?.title ?? '';
    final String voiceName = _voice?.voiceName ?? 'System Voice';
    final String description = _voice?.description ?? 'Natural & soothing voice';

    final String initial = voiceName.isNotEmpty ? voiceName[0].toUpperCase() : 'S';

    final String? photoPath = _voice?.photoPath;
    final Widget avatarWidget;

    if (photoPath != null && photoPath.isNotEmpty) {
      final String photoUrl = photoPath.startsWith('http')
          ? photoPath
          : Supabase.instance.client.storage.from('voice-images').getPublicUrl(photoPath);
      avatarWidget = CachedNetworkImage(
        imageUrl: photoUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1F2937),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF111827),
            border: Border.all(
              color: const Color(0xFF1F2937),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Text(
              initial,
              style: GoogleFonts.nunito(
                color: const Color(0xFFFB923C),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF111827),
            border: Border.all(
              color: const Color(0xFF1F2937),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Text(
              initial,
              style: GoogleFonts.nunito(
                color: const Color(0xFFFB923C),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      avatarWidget = Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF111827),
          border: Border.all(
            color: const Color(0xFF1F2937),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ],
        ),
        child: Center(
          child: Text(
            initial,
            style: GoogleFonts.nunito(
              color: const Color(0xFFFB923C),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final double maxVal = _duration.inMilliseconds.toDouble();
    final double currVal = _position.inMilliseconds.toDouble().clamp(0.0, maxVal);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Top navigation row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                LocalizedPlayer.getListeningMode(lang),
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFFFB923C),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 3),
                    // Center Avatar and Pulse Animation
                    Center(
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: ConcentricRingsAnimation(
                          isPlaying: _audioPlayer.playing,
                          child: avatarWidget,
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    // Progress Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFFB923C),
                        inactiveTrackColor: const Color(0xFF1F2937),
                        thumbColor: const Color(0xFFFB923C),
                        overlayColor: const Color(0xFFFB923C).withValues(alpha: 0.2),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: currVal,
                        min: 0.0,
                        max: maxVal > 0.0 ? maxVal : 1.0,
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(milliseconds: value.toInt()));
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
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    // Playback Controls Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _rewind10Seconds,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.replay_10_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 32),
                        GestureDetector(
                          onTap: _togglePlay,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFB923C),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _audioPlayer.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        IconButton(
                          onPressed: _forward10Seconds,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.forward_10_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    // Narrator voice information
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF1F2937),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LocalizedPlayer.getNarratorLabel(lang),
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  voiceName,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LocalizedPlayer.getVoiceDescriptionLabel(lang),
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    // Bottom Privacy Label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF38BDF8),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          LocalizedPlayer.getPrivacyLabel(lang),
                          style: GoogleFonts.quicksand(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LocalizedPlayer {
  static String getListeningMode(String lang) {
    switch (lang) {
      case 'ta':
        return 'கேட்கும் முறை';
      case 'te':
        return 'వినే విధానం';
      case 'en':
      default:
        return 'LISTENING MODE';
    }
  }

  static String getNarratorLabel(String lang) {
    switch (lang) {
      case 'ta':
        return 'குரல் வழங்குபவர்:';
      case 'te':
        return 'వ్యాఖ్యాత:';
      case 'en':
      default:
        return 'Narrator:';
    }
  }

  static String getVoiceDescriptionLabel(String lang) {
    switch (lang) {
      case 'ta':
        return 'குரல் விளக்கம்:';
      case 'te':
        return 'స్వర వివరణ:';
      case 'en':
      default:
        return 'Voice Description:';
    }
  }

  static String getPrivacyLabel(String lang) {
    switch (lang) {
      case 'ta':
        return 'உள்ளூர் பாதுகாப்பான ஒலி';
      case 'te':
        return 'స్థానిక సురక్షిత ఆడియో';
      case 'en':
      default:
        return 'LOCAL SECURE AUDIO';
    }
  }

  static String getErrorLoading(String lang) {
    switch (lang) {
      case 'ta':
        return 'ஒலியை ஏற்ற முடியவில்லை';
      case 'te':
        return 'ఆడియోను లోడ్ చేయడం విఫలమైంది';
      case 'en':
      default:
        return 'Failed to load audio';
    }
  }

  static String getRetryButton(String lang) {
    switch (lang) {
      case 'ta':
        return 'மீண்டும் முயற்சிக்கவும்';
      case 'te':
        return 'మళ్లీ ప్రయత్ండి';
      case 'en':
      default:
        return 'Tap to retry';
    }
  }
}
