
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

/// Data class returned when user completes the voice details form.
class VoiceDetailsResult {
  final String filePath;
  final String fileName;
  final int fileSize;
  final String voiceName;
  final String? description;
  final String language;
  final Duration audioDuration;

  VoiceDetailsResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.voiceName,
    this.description,
    required this.language,
    required this.audioDuration,
  });
}

class VoiceDetailsScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final int fileSize;

  const VoiceDetailsScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileSize,
  });

  @override
  State<VoiceDetailsScreen> createState() => _VoiceDetailsScreenState();
}

class _VoiceDetailsScreenState extends State<VoiceDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _voiceNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedLanguage;
  final List<String> _languages = ['English', 'Tamil', 'Telugu', 'Hindi'];

  AudioPlayer? _audioPlayer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isPlayerLoading = true;
  bool _playerHasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _voiceNameController.dispose();
    _descriptionController.dispose();
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    setState(() {
      _isPlayerLoading = true;
      _playerHasError = false;
    });

    try {
      final player = AudioPlayer();
      _audioPlayer = player;

      final resolvedDuration = await player.setFilePath(widget.filePath);
      if (resolvedDuration != null) {
        setState(() => _duration = resolvedDuration);
      }

      player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.processingState == ProcessingState.completed) {
              player.seek(Duration.zero);
              player.pause();
            }
          });
        }
      });

      player.positionStream.listen((pos) {
        if (mounted) setState(() => _position = pos);
      });

      player.durationStream.listen((dur) {
        if (mounted && dur != null) setState(() => _duration = dur);
      });

      setState(() => _isPlayerLoading = false);
    } catch (e) {
      debugPrint('VoiceDetails Player Error: $e');
      setState(() {
        _isPlayerLoading = false;
        _playerHasError = true;
      });
    }
  }

  Future<void> _disposePlayer() async {
    try {
      await _audioPlayer?.stop();
      await _audioPlayer?.dispose();
    } catch (_) {}
    _audioPlayer = null;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  void _onSave() {
    // Validate language separately since it's not a TextFormField
    if (_selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a language.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final result = VoiceDetailsResult(
        filePath: widget.filePath,
        fileName: widget.fileName,
        fileSize: widget.fileSize,
        voiceName: _voiceNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        language: _selectedLanguage!,
        audioDuration: _duration,
      );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Duration header ──
                      Center(
                        child: Column(
                          children: [
                            Text(
                              _isPlayerLoading ? '...' : _formatDuration(_duration),
                              style: GoogleFonts.nunito(
                                color: const Color(0xFFFB923C),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Duration',
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Avatar / Audio preview card ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1F2937),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Circular avatar with sound ring
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2E2319),
                                border: Border.all(
                                  color: const Color(0xFFFB923C).withValues(alpha: 0.4),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFB923C).withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xFFFB923C),
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Voice of the Beloved',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Set a name for a peaceful rest.',
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Audio controls ──
                            if (_isPlayerLoading)
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
                                  ),
                                ),
                              )
                            else if (_playerHasError)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'Unable to preview audio.',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            else ...[
                              // Seek slider
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFFFB923C),
                                    inactiveTrackColor: const Color(0xFF1F2937),
                                    thumbColor: const Color(0xFFFB923C),
                                    overlayColor: const Color(0xFFFB923C).withValues(alpha: 0.2),
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                  ),
                                  child: Slider(
                                    value: _position.inMilliseconds.toDouble().clamp(
                                        0.0, _duration.inMilliseconds.toDouble()),
                                    min: 0.0,
                                    max: _duration.inMilliseconds.toDouble() > 0
                                        ? _duration.inMilliseconds.toDouble()
                                        : 1.0,
                                    onChanged: (v) {
                                      _audioPlayer?.seek(Duration(milliseconds: v.toInt()));
                                    },
                                  ),
                                ),
                              ),
                              // Time labels
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_position),
                                      style: GoogleFonts.quicksand(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: GoogleFonts.quicksand(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Play/Pause/Restart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
                                    onPressed: () {
                                      _audioPlayer?.seek(Duration.zero);
                                      _audioPlayer?.play();
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      if (_isPlaying) {
                                        _audioPlayer?.pause();
                                      } else {
                                        _audioPlayer?.play();
                                      }
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFB923C),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Memory Title / Voice Name field ──
                      Text(
                        'Memory Title',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _voiceNameController,
                        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "e.g. Grandma's Bedtime Prayer",
                          hintStyle: GoogleFonts.quicksand(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF111827),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1F2937)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1F2937)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFFB923C), width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          errorStyle: GoogleFonts.quicksand(color: Colors.redAccent, fontSize: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Voice name is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // ── Personal Note / Description field ──
                      Text(
                        'Personal Note',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'A gentle recording from last summer...',
                          hintStyle: GoogleFonts.quicksand(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF111827),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1F2937)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFF1F2937)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFFB923C), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Language Spoken ──
                      Text(
                        'Language Spoken',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ..._languages.map((lang) {
                        final isSelected = _selectedLanguage == lang;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedLanguage = lang),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFB923C)
                                    : const Color(0xFF111827),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFB923C)
                                      : const Color(0xFF1F2937),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  lang,
                                  style: GoogleFonts.quicksand(
                                    color: isSelected ? Colors.black : const Color(0xFF9CA3AF),
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 32),

                      // ── Save button ──
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB923C),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.favorite_rounded, size: 20),
                          label: Text(
                            'Save to Sanctuary',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Delete Voice button ──
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Delete Voice',
                            style: GoogleFonts.quicksand(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Privacy notice ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF1F2937),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_rounded, color: Color(0xFF4ADE80), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This voice recording is encrypted and stored only on your device. We never upload your personal memories.',
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
