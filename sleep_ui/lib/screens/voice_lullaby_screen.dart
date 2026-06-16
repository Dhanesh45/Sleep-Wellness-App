import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sleep_ui/story/models/voice_clone.dart';
import 'package:sleep_ui/screens/voice_record_screen.dart';

class VoiceLullabyScreen extends StatefulWidget {
  const VoiceLullabyScreen({super.key});

  @override
  State<VoiceLullabyScreen> createState() => _VoiceLullabyScreenState();
}

class _VoiceLullabyScreenState extends State<VoiceLullabyScreen> {
  PlatformFile? _selectedFile;
  AudioPlayer? _audioPlayer;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isPlayerLoading = false;
  bool _playerHasError = false;
  String? _playerErrorMessage;
  List<VoiceClone> _userVoices = [];
  bool _isLoadingVoices = true;

  @override
  void initState() {
    super.initState();
    _loadUserVoices();
  }

  Future<void> _loadUserVoices() async {
    setState(() {
      _isLoadingVoices = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('voice_clones')
            .select('*')
            .eq('userid', user.id)
            .order('createdat', ascending: false);

        final List<dynamic> data = response as List<dynamic>;
        if (mounted) {
          setState(() {
            _userVoices = data.map((e) => VoiceClone.fromMap(e)).toList();
            _isLoadingVoices = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _userVoices = [];
            _isLoadingVoices = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user voices: $e');
      if (mounted) {
        setState(() {
          _isLoadingVoices = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initPlayer(String filePath) async {
    await _disposePlayer();

    setState(() {
      _isPlayerLoading = true;
      _playerHasError = false;
      _playerErrorMessage = null;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    try {
      final player = AudioPlayer();
      _audioPlayer = player;

      debugPrint('Player: Initializing audio player for local file: $filePath');
      
      final resolvedDuration = await player.setFilePath(filePath);
      if (resolvedDuration != null) {
        setState(() {
          _duration = resolvedDuration;
        });
      }

      player.playerStateStream.listen((state) {
        debugPrint('Player Event: processingState = ${state.processingState}, playing = ${state.playing}');
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
        if (mounted) {
          setState(() {
            _position = pos;
          });
        }
      });

      player.durationStream.listen((dur) {
        if (mounted && dur != null) {
          setState(() {
            _duration = dur;
          });
        }
      });

      setState(() {
        _isPlayerLoading = false;
      });
    } catch (e) {
      debugPrint('Player Error: Failed to initialize audio preview: $e');
      setState(() {
        _isPlayerLoading = false;
        _playerHasError = true;
        _playerErrorMessage = 'Unsupported or invalid audio format.';
      });
    }
  }

  Future<void> _disposePlayer() async {
    if (_audioPlayer != null) {
      debugPrint('Player: Disposing audio player');
      try {
        await _audioPlayer!.stop();
        await _audioPlayer!.dispose();
      } catch (e) {
        debugPrint('Player Error: Error disposing player: $e');
      }
      _audioPlayer = null;
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav', 'mp3', 'm4a', 'aac', 'ogg'],
      );

      if (result != null && result.files.single.path != null) {
        final PlatformFile file = result.files.single;
        final String filePath = file.path!;
        final String fileName = file.name;
        final int fileSize = file.size;

        // Print requirements
        debugPrint('--- Audio File Uploaded ---');
        debugPrint('File Path: $filePath');
        debugPrint('File Name: $fileName');
        debugPrint('File Size: $fileSize bytes');

        // Verify file exists
        final bool exists = await File(filePath).exists();
        debugPrint('File exists check: $exists');

        if (exists) {
          setState(() {
            _selectedFile = file;
          });

          await _initPlayer(filePath);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Successfully loaded: $fileName',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFFB923C),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          setState(() {
            _selectedFile = null;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selected file could not be verified on disk.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      } else {
        debugPrint('User canceled file picker');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _clearSelectedFile() async {
    await _disposePlayer();
    setState(() {
      _selectedFile = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File removed.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  void _generateSleepAudio() {
    if (_selectedFile == null) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111827),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF1F2937), width: 1),
          ),
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFFB923C)),
              const SizedBox(width: 8),
              Text(
                'Generating Sleep Audio',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Successfully selected "${_selectedFile!.name}".',
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'Local voice processing feature mock run completed. Supabase database sync & Cartesia voice synthesis will follow in the next steps.',
                style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 12, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Dismiss',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFFFB923C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Voice Lullaby',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Select or upload an audio file to generate a personalized sleep lullaby.'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Sound Wave Circle Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2E2319),
                          border: Border.all(
                            color: const Color(0xFFFB923C).withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFB923C).withValues(alpha: 0.05),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 3,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 3,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 3,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Titles
                    Center(
                      child: Text(
                        'Record or Upload',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Create a personalized lullaby from a loved one's voice",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Button 1: Record New Message (Not implemented, shows SnackBar)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final recordedPath = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(builder: (context) => const VoiceRecordScreen()),
                          );
                          if (recordedPath != null && mounted) {
                            final file = File(recordedPath);
                            if (await file.exists()) {
                              final fileName = recordedPath.split(Platform.pathSeparator).last;
                              final fileSize = await file.length();
                              
                              setState(() {
                                _selectedFile = PlatformFile(
                                  name: fileName,
                                  size: fileSize,
                                  path: recordedPath,
                                );
                              });
                              await _initPlayer(recordedPath);
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded, color: Colors.black),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Successfully loaded recorded audio',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: const Color(0xFFFB923C),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB923C),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.mic, size: 20, color: Colors.black),
                        label: Text(
                          'Record New Message',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Button 2: Upload Audio File
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: _pickAudioFile,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF1F2937), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          backgroundColor: const Color(0xFF111827).withValues(alpha: 0.3),
                        ),
                        icon: const Icon(Icons.insert_drive_file_outlined, size: 20, color: Colors.white),
                        label: Text(
                          'Upload Audio File',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Selected File info container
                    if (_selectedFile != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _playerHasError
                                ? Colors.redAccent.withValues(alpha: 0.3)
                                : const Color(0xFFFB923C).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: _isPlayerLoading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Loading audio preview...',
                                        style: GoogleFonts.quicksand(
                                          color: const Color(0xFF9CA3AF),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // File Title & Size info row
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: _playerHasError
                                            ? Colors.redAccent.withValues(alpha: 0.1)
                                            : const Color(0xFF1F2937),
                                        child: Icon(
                                          _playerHasError
                                              ? Icons.error_outline_rounded
                                              : Icons.audiotrack_rounded,
                                          color: _playerHasError ? Colors.redAccent : const Color(0xFFFB923C),
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedFile!.name,
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _playerHasError
                                                  ? (_playerErrorMessage ?? 'Error loading audio')
                                                  : _formatFileSize(_selectedFile!.size),
                                              style: GoogleFonts.quicksand(
                                                color: _playerHasError ? Colors.redAccent : const Color(0xFF9CA3AF),
                                                fontSize: 11,
                                                fontWeight: _playerHasError ? FontWeight.w600 : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                                        onPressed: _clearSelectedFile,
                                      ),
                                    ],
                                  ),
                                  if (!_playerHasError) ...[
                                    const SizedBox(height: 16),
                                    // Audio Seek Slider
                                    SliderTheme(
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
                                        value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
                                        min: 0.0,
                                        max: _duration.inMilliseconds.toDouble() > 0.0 ? _duration.inMilliseconds.toDouble() : 1.0,
                                        onChanged: (value) {
                                          _audioPlayer?.seek(Duration(milliseconds: value.toInt()));
                                        },
                                      ),
                                    ),
                                    // Timing labels row
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    const SizedBox(height: 12),
                                    // Control buttons: Play/Pause/Restart
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Restart button
                                        IconButton(
                                          icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
                                          onPressed: () {
                                            _audioPlayer?.seek(Duration.zero);
                                            _audioPlayer?.play();
                                          },
                                          tooltip: 'Restart',
                                        ),
                                        const SizedBox(width: 20),
                                        // Play/Pause button
                                        GestureDetector(
                                          onTap: () {
                                            if (_isPlaying) {
                                              _audioPlayer?.pause();
                                            } else {
                                              _audioPlayer?.play();
                                            }
                                          },
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFB923C),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    ],
                    const SizedBox(height: 36),
                    // Your Voice Library section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Voice Library',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice library viewing coming soon!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Text(
                            'See All',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFB923C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingVoices) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Loading your voices...',
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (_userVoices.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF1F2937),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.voice_over_off_outlined,
                              color: const Color(0xFF9CA3AF).withValues(alpha: 0.5),
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No Cloned Voices Yet',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Upload an audio file above and complete voice generation to see your cloned voices listed here.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Column(
                        children: _userVoices.map((voice) {
                          final String initial = voice.voiceName.isNotEmpty ? voice.voiceName[0].toUpperCase() : 'V';
                          final String? photoPath = voice.photoPath;
                          final Widget avatar;

                          if (photoPath != null && photoPath.isNotEmpty) {
                            final String photoUrl = photoPath.startsWith('http')
                                ? photoPath
                                : Supabase.instance.client.storage.from('voice-images').getPublicUrl(photoPath);
                            avatar = CachedNetworkImage(
                              imageUrl: photoUrl,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 20,
                                backgroundImage: imageProvider,
                                backgroundColor: const Color(0xFF111827),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF111827),
                                child: Text(
                                  initial,
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xFFFB923C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF111827),
                                child: Text(
                                  initial,
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xFFFB923C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            avatar = CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF111827),
                              child: Text(
                                initial,
                                style: GoogleFonts.nunito(
                                  color: const Color(0xFFFB923C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
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
                                children: [
                                  avatar,
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          voice.voiceName,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (voice.description != null && voice.description!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            voice.description!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.quicksand(
                                              color: const Color(0xFF9CA3AF),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F2937),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      voice.language.toUpperCase(),
                                      style: GoogleFonts.quicksand(
                                        color: const Color(0xFFFB923C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Local Safeguard Architecture Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161F30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1F2937),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: Color(0xFF34D399),
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Local Safe-Guard Architecture',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your voice data is processed locally on this device. It never leaves your phone and is never shared with third parties.',
                                  style: GoogleFonts.quicksand(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Bottom Sticky Button: Generate Sleep Audio
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _selectedFile != null ? _generateSleepAudio : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFile != null
                        ? const Color(0xFFFB923C)
                        : const Color(0xFF2C2216),
                    foregroundColor: _selectedFile != null ? Colors.black : Colors.grey,
                    disabledBackgroundColor: const Color(0xFF2C2216),
                    disabledForegroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: _selectedFile != null ? Colors.black : Colors.grey,
                  ),
                  label: Text(
                    'Generate Sleep Audio',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _selectedFile != null ? Colors.black : Colors.grey,
                    ),
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
