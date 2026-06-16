import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sleep_ui/story/models/story_template.dart';
import 'package:sleep_ui/story/models/voice_clone.dart';
import 'package:sleep_ui/story/screens/story_audio_player_screen.dart';
import 'package:sleep_ui/screens/voice_lullaby_screen.dart';

class StoryDetailsScreen extends StatefulWidget {
  final StoryTemplate story;

  const StoryDetailsScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  bool _isFavorite = false;
  bool _isLoadingNarrators = false;
  List<VoiceClone> _narrators = [];
  String? _selectedVoiceId;
  final Map<String, String> _voiceAudioPaths = {};

  @override
  void initState() {
    super.initState();
    _loadNarrators();
  }

  Future<void> _navigateToPlayer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryAudioPlayerScreen(
          storyid: widget.story.storyid,
          voiceid: _selectedVoiceId ?? 'system',
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  // Load available narrators for this story
  Future<void> _loadNarrators() async {
    setState(() {
      _isLoadingNarrators = true;
      _voiceAudioPaths.clear();
    });

    List<String> voiceIds = [];
    try {
      // 1. Fetch audio versions matching this storyid
      final versionsResponse = await Supabase.instance.client
          .from('story_audio_versions')
          .select('voiceid, audio_path')
          .eq('storyid', widget.story.storyid);

      final List<dynamic> versionsData = versionsResponse as List<dynamic>;
      
      // Store the voice-to-audio path mapping
      for (var version in versionsData) {
        if (version['voiceid'] != null && version['audio_path'] != null) {
          _voiceAudioPaths[version['voiceid'].toString()] = version['audio_path'].toString();
        }
      }
      voiceIds = _voiceAudioPaths.keys.toList();
    } catch (e) {
      debugPrint('Error loading story_audio_versions: $e');
    }

    List<dynamic> voicesData = [];
    try {
      if (voiceIds.isNotEmpty) {
        // 2. Fetch the corresponding clones
        final voicesResponse = await Supabase.instance.client
            .from('voice_clones')
            .select('*')
            .inFilter('voiceid', voiceIds);
        voicesData = voicesResponse as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Error loading voice_clones for associated audio: $e');
    }

    // 3. Fallback: if no associated audio versions/voice clones found, load voice clones matching the story's language
    if (voicesData.isEmpty) {
      try {
        final fallbackResponse = await Supabase.instance.client
            .from('voice_clones')
            .select('*')
            .eq('language', widget.story.language);
        voicesData = fallbackResponse as List<dynamic>;
      } catch (e) {
        debugPrint('Error loading fallback voice_clones: $e');
      }
    }

    setState(() {
      _narrators = voicesData.map((e) => VoiceClone.fromMap(e)).toList();
      if (_narrators.isNotEmpty) {
        _selectedVoiceId = _narrators.first.voiceid;
      } else {
        _selectedVoiceId = 'system';
      }
      _isLoadingNarrators = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeaderHeight = screenHeight * 0.45; // ocupies 45% of screen height
    final bool isWide = MediaQuery.of(context).size.width > 600;

    Widget pageBody = Stack(
      children: [
        // Main Scrollable Content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Stack at the top
              _buildHeroHeader(imageHeaderHeight),
              // Body Content (Titles, Descriptions, Narrator Selector)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About the Story Section
                    _buildAboutSection(),
                    const SizedBox(height: 24),
                    const Divider(
                      color: Color(0xFF1F2937),
                      thickness: 1,
                    ),
                    const SizedBox(height: 24),
                    // Choose Narrator Section
                    _buildNarratorSection(),
                    const SizedBox(height: 120), // Padding bottom for sticky bottom bar overlap
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // If wide screen (tablet/desktop test environment constraints)
    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFF050814),
        bottomNavigationBar: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: _buildBottomActionArea(),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: pageBody,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      bottomNavigationBar: _buildBottomActionArea(),
      body: pageBody,
    );
  }

  // --- Hero Header Stack ---
  Widget _buildHeroHeader(double headerHeight) {
    // Generate placeholder if thumbnailPath is null/invalid
    final String imageUrl = widget.story.thumbnailPath != null && widget.story.thumbnailPath!.startsWith('http')
        ? widget.story.thumbnailPath!
        : 'https://images.unsplash.com/photo-1511289081367-4daa7e4524c7?w=600';

    final String lang = widget.story.language;

    return Stack(
      children: [
        // 1. Hero Image
        SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: widget.story.thumbnailPath != null && widget.story.thumbnailPath!.startsWith('assets/')
              ? Image.asset(
                  widget.story.thumbnailPath!,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF111827),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF111827),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFFB923C)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF111827),
                    child: Image.asset(
                      'assets/images/ravenstorytb.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
        ),
        // 2. Dark Gradient Overlay (top-to-bottom and bottom-to-top)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // 3. Top Action Buttons (Back + Favorite)
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              // Favorite Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? const Color(0xFFFB923C) : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 4. Overlaid Text Metadata (Bottom part of Stack)
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Story Category Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  LocalizedDetails.getCategoryBadge(lang),
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Story Title - Protected against overflow
              Text(
                widget.story.title,
                softWrap: true,
                maxLines: 3,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Story Meta Row (Duration + Category)
              Row(
                children: [
                  // Duration
                  const Icon(
                    Icons.access_time,
                    color: const Color(0xFFFB923C),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    LocalizedDetails.getDuration(widget.story.durationMinutes, lang),
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Category
                  const Icon(
                    Icons.graphic_eq_rounded,
                    color: const Color(0xFFFB923C),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      LocalizedDetails.getMetaCategory(lang),
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- About the Story Section ---
  Widget _buildAboutSection() {
    final String lang = widget.story.language;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizedDetails.getAboutTitle(lang),
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Description text - Protected against overflow (auto wrapping, no bounds)
        Text(
          widget.story.description,
          softWrap: true,
          style: GoogleFonts.quicksand(
            color: const Color(0xFF9CA3AF),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // --- Choose Narrator Section ---
  Widget _buildNarratorSection() {
    final String lang = widget.story.language;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          LocalizedDetails.getNarratorTitle(lang),
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // Subtitle
        Text(
          LocalizedDetails.getNarratorSubtitle(lang),
          style: GoogleFonts.quicksand(
            color: const Color(0xFF9CA3AF),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        // Narrator Horizontal List
        SizedBox(
          height: 110,
          child: _isLoadingNarrators
              ? _buildNarratorLoadingPlaceholder()
              : _buildNarratorHorizontalList(),
        ),
      ],
    );
  }

  Widget _buildRecordVoiceCard() {
    final String lang = widget.story.language;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VoiceLullabyScreen()),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
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
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF111827),
              child: Icon(
                Icons.mic_none_rounded,
                color: Color(0xFFFB923C),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocalizedDetails.getRecordVoiceTitle(lang),
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocalizedDetails.getRecordVoiceSubtitle(lang),
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 10,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Narrator Horizontal List ---
  Widget _buildNarratorHorizontalList() {
    final bool showSystemFallback = _narrators.isEmpty;
    final int itemCount = showSystemFallback ? 2 : _narrators.length + 1;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildRecordVoiceCard();
        }

        if (showSystemFallback) {
          final String defaultName = widget.story.language == 'ta'
              ? 'முறைமை குரல்'
              : widget.story.language == 'te'
                  ? 'సిస్టమ్ వాయిస్'
                  : 'System Voice';

          final String defaultDesc = widget.story.language == 'ta'
              ? 'இயற்கையான மற்றும் அமைதியான குரல்'
              : widget.story.language == 'te'
                  ? 'సహజమైన మరియు ప్రశాంతమైన స్వరం'
                  : 'Natural & soothing voice';

          final bool isSelected = _selectedVoiceId == 'system' || _selectedVoiceId == null;
          return _buildNarratorCard(defaultName, defaultDesc, 'system', isSelected);
        }

        final voice = _narrators[index - 1];
        final bool isSelected = _selectedVoiceId == voice.voiceid;

        return _buildNarratorCard(
          voice.voiceName,
          voice.description ?? 'Narrator voice',
          voice.voiceid,
          isSelected,
          photoPath: voice.photoPath,
        );
      },
    );
  }

  // --- Narrator Loading State Placeholder ---
  Widget _buildNarratorLoadingPlaceholder() {
    return Row(
      children: List.generate(2, (index) {
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1F2937),
              width: 1,
            ),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFFB923C)),
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- Narrator Card Builder ---
  Widget _buildNarratorCard(
    String name,
    String desc,
    String id,
    bool isSelected, {
    String? photoPath,
  }) {
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    final Widget avatar;

    if (photoPath != null && photoPath.isNotEmpty) {
      final String photoUrl = photoPath.startsWith('http')
          ? photoPath
          : Supabase.instance.client.storage.from('voice-images').getPublicUrl(photoPath);
      avatar = CachedNetworkImage(
        imageUrl: photoUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 18,
          backgroundImage: imageProvider,
          backgroundColor: const Color(0xFF111827),
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF111827),
          child: Text(
            initial,
            style: GoogleFonts.nunito(
              color: const Color(0xFFFB923C),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF111827),
          child: Text(
            initial,
            style: GoogleFonts.nunito(
              color: const Color(0xFFFB923C),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      avatar = CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFF111827),
        child: Text(
          initial,
          style: GoogleFonts.nunito(
            color: const Color(0xFFFB923C),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVoiceId = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFB923C).withValues(alpha: 0.1) 
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFB923C) : const Color(0xFF1F2937),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFB923C).withValues(alpha: 0.15),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFFB923C),
                          size: 14,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 10,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Sticky Bottom Action Area ---
  Widget _buildBottomActionArea() {
    final String lang = widget.story.language;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F19), // Dark sticky background
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1E293B).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Primary Play Story Button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _navigateToPlayer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB923C), // Orange primary
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          size: 24,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          LocalizedDetails.getPlayButton(lang),
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Privacy Label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Color(0xFF38BDF8),
                size: 13,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  LocalizedDetails.getPrivacyLabel(lang),
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// --- Localized String Cache for Details Screen ---
class LocalizedDetails {
  static String getCategoryBadge(String lang) {
    switch (lang) {
      case 'ta':
        return 'தூக்கக் கதை';
      case 'te':
        return 'నిద్ర కథ';
      case 'en':
      default:
        return 'BEDTIME STORY';
    }
  }

  static String getDuration(int mins, String lang) {
    switch (lang) {
      case 'ta':
        return '$mins நிமிடம்';
      case 'te':
        return '$mins నిమిషాలు';
      case 'en':
      default:
        return '$mins mins';
    }
  }

  static String getMetaCategory(String lang) {
    switch (lang) {
      case 'ta':
        return 'அமைதியான காடு';
      case 'te':
        return 'ప్రశాంతమైన అడవి';
      case 'en':
      default:
        return 'Ambient Forest';
    }
  }

  static String getAboutTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'கதையைப் பற்றி';
      case 'te':
        return 'కథ గురించి';
      case 'en':
      default:
        return 'About the Story';
    }
  }

  static String getNarratorTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'குரலைத் தேர்ந்தெடுக்கவும்';
      case 'te':
        return 'వాయిస్ను ఎంచుకోండి';
      case 'en':
      default:
        return 'Choose Narrator';
    }
  }

  static String getNarratorSubtitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'உங்களுக்கு நெருக்கமாக உணரப்படும் குரலைத் தேர்ந்தெடுக்கவும்.';
      case 'te':
        return 'మీకు సౌకర్యంగా అనిపించే స్వరాన్ని ఎంచుకోండి.';
      case 'en':
      default:
        return 'Select a voice that feels safest for your mind.';
    }
  }

  static String getPlayButton(String lang) {
    switch (lang) {
      case 'ta':
        return 'கதையை கேளுங்கள்';
      case 'te':
        return 'கథను వినండి';
      case 'en':
      default:
        return 'Play Story';
    }
  }

  static String getPauseButton(String lang) {
    switch (lang) {
      case 'ta':
        return 'கதையை நிறுத்து';
      case 'te':
        return 'కథను నిలిపివేయి';
      case 'en':
      default:
        return 'Pause Story';
    }
  }

  static String getRecordVoiceTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'குரலைப் பதிவுசெய்';
      case 'te':
        return 'వాయిస్ రికార్డ్ చేయి';
      case 'en':
      default:
        return 'Record Voice';
    }
  }

  static String getRecordVoiceSubtitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'நகல் உருவாக்கு';
      case 'te':
        return 'క్లోన్ సృష్టించు';
      case 'en':
      default:
        return 'Create clone';
    }
  }

  static String getRecordingComingSoon(String lang) {
    switch (lang) {
      case 'ta':
        return 'குரல் பதிவு அம்சம் விரைவில் வருகிறது!';
      case 'te':
        return 'వాయిస్ రికార్డింగ్ ఫీచర్ త్వరలో వస్తుంది!';
      case 'en':
      default:
        return 'Voice recording feature coming soon!';
    }
  }

  static String getPrivacyLabel(String lang) {
    switch (lang) {
      case 'ta':
        return 'உங்கள் தனியுரிமைக்காக உள்ளூரில் செயலாக்கப்படுகிறது';
      case 'te':
        return 'మీ గోప్యత కోసం స్థానికంగా ప్రాసెస్ చేయబడుతుంది';
      case 'en':
      default:
        return 'Processed locally for your privacy';
    }
  }
}
