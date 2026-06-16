import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sleep_ui/story/models/story_template.dart';
import 'package:sleep_ui/story/widgets/story_card.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  String _selectedLanguage = 'en'; // default selected language
  bool _isLoading = false;
  String? _errorMessage;
  List<StoryTemplate> _stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  // Fetch stories matching selected language from Supabase
  Future<void> _loadStories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Supabase.instance.client
          .from('story_templates')
          .select('*')
          .eq('language', _selectedLanguage)
          .order('createdat', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      setState(() {
        _stories = data.map((json) => StoryTemplate.fromMap(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onLanguageSelected(String lang) {
    if (_selectedLanguage == lang) return;
    setState(() {
      _selectedLanguage = lang;
    });
    _loadStories();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 600;

    Widget bodyContent;
    if (_errorMessage != null) {
      bodyContent = _buildErrorState();
    } else {
      bodyContent = SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 24 : 16,
          vertical: 20,
        ).copyWith(bottom: 120), // padding bottom for navigation pill space
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            _buildVoiceCloneCard(),
            const SizedBox(height: 28),
            _buildBedtimeStoriesHeader(),
            const SizedBox(height: 16),
            if (_isLoading)
              _buildLoadingPlaceholder()
            else if (_stories.isEmpty)
              _buildEmptyState()
            else
              _buildStoriesList(),
            const SizedBox(height: 24),
            _buildPrivacyCard(),
          ],
        ),
      );
    }

    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFF050814),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: bodyContent,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      body: SafeArea(child: bodyContent),
    );
  }

  // --- Header ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocalizedStrings.getTitle(_selectedLanguage),
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            // Settings action (no navigation per spec)
          },
        ),
      ],
    );
  }

  // --- Language Selector ---
  Widget _buildLanguageSelector() {
    final languages = [
      {'code': 'en', 'label': 'English'},
      {'code': 'ta', 'label': 'தமிழ்'},
      {'code': 'te', 'label': 'తెలుగు'},
    ];

    return Row(
      children: languages.map((lang) {
        final bool isSelected = _selectedLanguage == lang['code'];
        return GestureDetector(
          onTap: () => _onLanguageSelected(lang['code']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFB923C) // Orange background
                  : const Color(0xFF1F2937), // Dark gray background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFFB923C) : const Color(0xFF374151),
                width: 1,
              ),
            ),
            child: Text(
              lang['label']!,
              style: GoogleFonts.quicksand(
                color: isSelected ? Colors.white : const Color(0xFF9CA3AF), // White or light gray
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Voice Clone Card ---
  Widget _buildVoiceCloneCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice cloning coming soon'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFFFB923C),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF111827), // Dark card background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF1F2937),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Center Microphone Button
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFB923C),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFB923C).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic,
                color: Color(0xFFFB923C),
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              LocalizedStrings.getVoiceCloneTitle(_selectedLanguage),
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              LocalizedStrings.getVoiceCloneSubtitle(_selectedLanguage),
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                color: const Color(0xFF9CA3AF),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bedtime Stories Section Header ---
  Widget _buildBedtimeStoriesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            LocalizedStrings.getBedtimeStoriesTitle(_selectedLanguage),
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // See all action (no navigation per spec)
          },
          child: Text(
            LocalizedStrings.getSeeAll(_selectedLanguage),
            style: GoogleFonts.quicksand(
              color: const Color(0xFFFB923C),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // --- Stories List ---
  Widget _buildStoriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _stories.length,
      itemBuilder: (context, index) {
        return StoryCard(
          story: _stories[index],
        );
      },
    );
  }

  // --- Loading State (Animated Pulse Card Placeholders) ---
  Widget _buildLoadingPlaceholder() {
    return Column(
      children: const [
        AnimatedPulseCard(),
        AnimatedPulseCard(),
      ],
    );
  }

  // --- Empty State ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            const Icon(
              Icons.auto_stories_outlined,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              LocalizedStrings.getNoStories(_selectedLanguage),
              style: GoogleFonts.quicksand(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Privacy Card ---
  Widget _buildPrivacyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFF38BDF8), // Blue Accent
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              LocalizedStrings.getPrivacyText(_selectedLanguage),
              style: GoogleFonts.quicksand(
                color: const Color(0xFF9CA3AF),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Error State (Screenshot matching Postgrest error look with Retry) ---
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cloud Slash / Disconnected Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1C1A14), // Dark orange/brownish tint background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFFB923C), // Orange cloud slash
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? 'Connection to database failed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              color: const Color(0xFF9CA3AF),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loadStories,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB923C), // Orange button
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: Text(
                LocalizedStrings.getRetry(_selectedLanguage),
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Localized Strings Map ---
class LocalizedStrings {
  static String getTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'தூக்கக் கதைகள்';
      case 'te':
        return 'నిద్ర కథలు';
      case 'en':
      default:
        return 'Sleep Stories';
    }
  }

  static String getVoiceCloneTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'உங்களுக்குப் பிடித்தவரின் குரலைப் பயன்படுத்துங்கள்';
      case 'te':
        return 'మీ ప్రియమైన వ్యక్తి స్వరాన్ని క్లోన్ చేయండి';
      case 'en':
      default:
        return 'Clone a Loved One\'s Voice';
    }
  }

  static String getVoiceCloneSubtitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'ஒரு குரல் பதிவை பதிவேற்றி அவர்களின் குரலில் கதைகளை கேளுங்கள்';
      case 'te':
        return 'వారి స్వరంలో కథలు వినడానికి ఆడియోను అప్లోడ్ చేయండి';
      case 'en':
      default:
        return 'Upload a clip to hear stories in their voice';
    }
  }

  static String getBedtimeStoriesTitle(String lang) {
    switch (lang) {
      case 'ta':
        return 'படுக்கை நேரக் கதைகள்';
      case 'te':
        return 'నిద్రపోయే ముందు కథలు';
      case 'en':
      default:
        return 'Bedtime Stories';
    }
  }

  static String getSeeAll(String lang) {
    switch (lang) {
      case 'ta':
        return 'அனைத்தையும்';
      case 'te':
        return 'అన్నీ చూడండి';
      case 'en':
      default:
        return 'See all';
    }
  }

  static String getPrivacyText(String lang) {
    switch (lang) {
      case 'ta':
        return 'உங்களுக்குப் பிடித்தவரின் குரல் உங்கள் சாதனத்திலேயே பாதுகாப்பாக செயலாக்கப்படும்.';
      case 'te':
        return 'మీ ప్రియమైన వ్యక్తి స్వరం మీ పరికరంలోనే సురక్షితంగా ప్రాసెస్ చేయబడుతుంది.';
      case 'en':
      default:
        return 'Your loved one\'s voice is processed locally and never leaves your device.';
    }
  }

  static String getNoStories(String lang) {
    switch (lang) {
      case 'ta':
        return 'கதைகள் எதுவும் இல்லை';
      case 'te':
        return 'కథలు అందుబాటులో లేవు';
      case 'en':
      default:
        return 'No stories available';
    }
  }

  static String getRetry(String lang) {
    switch (lang) {
      case 'ta':
        return 'மீண்டும் முயற்சிக்கவும்';
      case 'te':
        return 'మళ్లీ ప్రయత్నించండి';
      case 'en':
      default:
        return 'Retry';
    }
  }
}

// --- Animated Pulse Card for Loading State ---
class AnimatedPulseCard extends StatefulWidget {
  const AnimatedPulseCard({super.key});

  @override
  State<AnimatedPulseCard> createState() => _AnimatedPulseCardState();
}

class _AnimatedPulseCardState extends State<AnimatedPulseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF1F2937),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area shimmer
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F2937),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  ),
                ),
                // Text placeholder
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2937),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
