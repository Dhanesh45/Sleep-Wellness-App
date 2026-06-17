import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sleep_ui/story/models/voice_clone.dart';
import 'package:sleep_ui/screens/voice_record_screen.dart';
import 'package:sleep_ui/screens/voice_details_screen.dart';
import 'package:uuid/uuid.dart';

class VoiceLullabyScreen extends StatefulWidget {
  const VoiceLullabyScreen({super.key});

  @override
  State<VoiceLullabyScreen> createState() => _VoiceLullabyScreenState();
}

class _VoiceLullabyScreenState extends State<VoiceLullabyScreen> {
  VoiceDetailsResult? _voiceDetails;
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
      // Query all voice clones to ensure friend voices (e.g. Rogith) show up in the library in this dev environment
      final query = Supabase.instance.client
          .from('voice_clones')
          .select('*');
      
      final response = await query.order('createdat', ascending: false);
      final List<dynamic> data = response as List<dynamic>;
      
      if (mounted) {
        setState(() {
          _userVoices = data.map((e) => VoiceClone.fromMap(e)).toList();
          _isLoadingVoices = false;
        });
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
    super.dispose();
  }

  /// Navigate to VoiceDetailsScreen with the given file info.
  Future<void> _navigateToVoiceDetails(String filePath, String fileName, int fileSize) async {
    final result = await Navigator.push<VoiceDetailsResult>(
      context,
      MaterialPageRoute(
        builder: (context) => VoiceDetailsScreen(
          filePath: filePath,
          fileName: fileName,
          fileSize: fileSize,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _voiceDetails = result;
      });
      // Auto-trigger audio upload to Supabase storage
      _generateSleepAudio();
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
        final bool exists = await File(filePath).exists();
        if (exists) {
          if (mounted) {
            await _navigateToVoiceDetails(filePath, file.name, file.size);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selected file could not be verified on disk.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
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

  void _clearVoiceDetails() {
    setState(() {
      _voiceDetails = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice entry removed.'),
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

  Future<void> _generateSleepAudio() async {
    if (_voiceDetails == null) return;
    
    final userId = 'f155eb97-7695-41a2-b5cc-2fbe93f3b80b';
    final voiceId = const Uuid().v4();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
        ),
      ),
    );

    try {
      final String langCode = {
        'english': 'en',
        'tamil': 'ta',
        'telugu': 'te',
        'hindi': 'hi',
      }[_voiceDetails!.language.toLowerCase()] ?? 'en';

      // Insert record directly into the voice_clones table
      await Supabase.instance.client.from('voice_clones').insert({
        'voiceid': voiceId,
        'userid': userId,
        'voice_name': _voiceDetails!.voiceName,
        'description': _voiceDetails!.description,
        'language': langCode,
        'cartesia_voice_id': 'mock-cartesia-${voiceId.substring(0, 8)}',
        'photo_path': null,
      });

      debugPrint('Successfully stored voice clone in database:');
      debugPrint('voiceid: $voiceId');
      debugPrint('userid: $userId');
      debugPrint('voice_name: ${_voiceDetails!.voiceName}');

      // Refresh the library so the new voice clone is loaded and displayed immediately
      await _loadUserVoices();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice saved to database successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Show success dialog
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
                    'Voice Generation Complete',
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
                    'Voice Name: "${_voiceDetails!.voiceName}" (${_voiceDetails!.language})',
                    style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The voice details have been stored successfully in the voice_clones table.',
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
    } catch (e) {
      debugPrint('Error inserting voice clone: $e');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
                              await _navigateToVoiceDetails(recordedPath, fileName, fileSize);
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
                    // ── Voice Details summary card ──
                    if (_voiceDetails != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFB923C).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row: avatar + name + close
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFF2E2319),
                                  child: Text(
                                    _voiceDetails!.voiceName.isNotEmpty
                                        ? _voiceDetails!.voiceName[0].toUpperCase()
                                        : 'V',
                                    style: GoogleFonts.nunito(
                                      color: const Color(0xFFFB923C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _voiceDetails!.voiceName,
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_formatFileSize(_voiceDetails!.fileSize)}  •  ${_formatDuration(_voiceDetails!.audioDuration)}',
                                        style: GoogleFonts.quicksand(
                                          color: const Color(0xFF9CA3AF),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F2937),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _voiceDetails!.language.substring(0, 2).toUpperCase(),
                                    style: GoogleFonts.quicksand(
                                      color: const Color(0xFFFB923C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                                  onPressed: _clearVoiceDetails,
                                ),
                              ],
                            ),
                            if (_voiceDetails!.description != null &&
                                _voiceDetails!.description!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                _voiceDetails!.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
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
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            // Bottom Sticky Button: Generate Sleep Audio has been removed per request.
            // Upload triggers automatically when details are saved.
          ],
        ),
      ),
    );
  }
}
