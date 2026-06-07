import 'package:flutter/material.dart';
import 'sleep_player.dart';

enum AudioHubTabMode { full, soundsOnly, storiesOnly }

class SleepDashboard extends StatelessWidget {
  final bool embedded;
  final AudioHubTabMode mode;

  const SleepDashboard({
    Key? key,
    this.embedded = false,
    this.mode = AudioHubTabMode.full,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFFCD3A1); // Accent Peach/Gold color

    return Scaffold(
      backgroundColor: const Color(0xFF090C10),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: embedded ? 100 : 140,
              ), // Space for mini-player and nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Good Evening',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.nightlight_round,
                                    color: themeColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const Text(
                                'What would you like to hear tonight?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Tags / Chips Row
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCategoryChip(
                          '😌 Relax',
                          isSelected: true,
                          accentColor: themeColor,
                        ),
                        _buildCategoryChip('🌧️ Rainy'),
                        _buildCategoryChip('🌲 Nature'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hero Banner (Ocean Dreams)
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SleepPlayer()),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'DEEP SLEEP COLLECTION',
                                    style: TextStyle(
                                      color: themeColor.withOpacity(0.8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const Text(
                                    'Ocean Dreams',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '45 Minutes',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: themeColor,
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SleepMate Recommends Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.05),
                          child: Icon(Icons.auto_awesome, color: themeColor),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SleepMate Recommends',
                          style: TextStyle(
                            color: themeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ocean Waves',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Because your recovery score was 15% lower than usual today. This will help lower your cortisol levels before bed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Listen Now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Media Sections
                  if (mode != AudioHubTabMode.storiesOnly)
                    _buildMediaSection('Natural Sounds', [
                      _buildMediaCard(
                        'Rain on Window',
                        'Soft loop • 60m',
                        'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=300',
                        '20:00',
                      ),
                      _buildMediaCard(
                        'Ocean Waves',
                        'Rhythmic blend',
                        'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=300',
                        '15:00',
                      ),
                    ]),

                  if (mode != AudioHubTabMode.soundsOnly)
                    _buildMediaSection('Bedtime Stories', [
                      _buildMediaCard(
                        'The Midnight Train',
                        'Fantasy • 22 min',
                        'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=300',
                        'Stephen Fry',
                        isStory: true,
                      ),
                      _buildMediaCard(
                        'Ocean\'s Whisper',
                        'Adventure • 35 min',
                        'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=300',
                        'Eva Green',
                        isStory: true,
                      ),
                    ]),

                  if (mode == AudioHubTabMode.full)
                    _buildMediaSection('Sleep Podcasts', [
                      _buildMediaCard(
                        'Sleep Better Tonight',
                        'Dr. Aris Thorne',
                        'https://images.unsplash.com/photo-1516280440614-37939bbacd6a?w=300',
                        '',
                      ),
                      _buildMediaCard(
                        'Science of Sleep',
                        'NeuroHub Studios',
                        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=300',
                        '',
                      ),
                    ]),
                ],
              ),
            ),

            // Persistent Mini Player and Bottom Navigation Overlay Bar
            if (!embedded)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mini Player UI
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F141C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ocean Dreams',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '15:02',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.skip_previous, color: Colors.white),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: themeColor,
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.skip_next, color: Colors.white),
                      ],
                    ),
                  ),

                  // Bottom Navigation Bar Layout
                  Container(
                    color: const Color(0xFF090C10),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home_outlined, 'Sanctuary', false),
                        _buildNavItem(Icons.wifi_tethering, 'Audio', false),
                        _buildNavItem(
                          Icons.bar_chart_outlined,
                          'Wellness',
                          false,
                        ),
                        _buildNavItem(
                          Icons.bedtime,
                          'Sleep',
                          true,
                          themeColor: themeColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label, {
    bool isSelected = false,
    Color? accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? accentColor : const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.white10,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'View All',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCard(
    String title,
    String subtitle,
    String imageUrl,
    String dynamicTag, {
    bool isStory = false,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (dynamicTag.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dynamicTag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected, {
    Color? themeColor,
  }) {
    return isSelected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black, size: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          );
  }
}
