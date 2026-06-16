import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'sleep_player.dart';

enum AudioHubTabMode { full, soundsOnly, storiesOnly }

class SleepDashboard extends StatefulWidget {
  final bool embedded;
  final AudioHubTabMode mode;

  const SleepDashboard({
    Key? key,
    this.embedded = false,
    this.mode = AudioHubTabMode.full,
  }) : super(key: key);

  @override
  State<SleepDashboard> createState() => _SleepDashboardState();
}

class _SleepDashboardState extends State<SleepDashboard> {
  late AudioPlayer _player;
  final Color themeColor = const Color(0xFFFFB03A);
  String _currentlyPlaying = "None";

  // --- SUPABASE BUCKET URL ---
  final String supabaseBaseUrl =
      'https://puzmgqkeiwmbxeknqdom.supabase.co/storage/v1/object/public/audio%20files/';

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Logic to play sound from Supabase
  Future<void> _playNaturalSound(String soundFileName) async {
    try {
      if (soundFileName.isEmpty) return;

      // Stop current sound to clear buffer before switching
      await _player.stop();

      // Construct the full URL
      final String fullUrl = '$supabaseBaseUrl$soundFileName.mp3';

      await _player.setUrl(fullUrl);
      await _player.setLoopMode(LoopMode.all);

      setState(() {
        _currentlyPlaying = soundFileName.replaceAll('_', ' ').toUpperCase();
      });

      _player.play();
    } catch (e) {
      debugPrint("Error loading audio from Supabase: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Could not load $soundFileName")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: widget.embedded ? 100 : 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildTagsRow(),
                  const SizedBox(height: 20),
                  _buildHeroBanner(context),
                  const SizedBox(height: 20),

                  // NATURAL SOUNDS SECTION - 17 CARDS
                  if (widget.mode != AudioHubTabMode.storiesOnly)
                    _buildMediaSection('Natural Sounds', [
                      _buildMediaCard(
                        'Blizzard',
                        'Icy wind',
                        'https://images.unsplash.com/photo-1701809922861-6f650117c966?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJsaXp6YXJkfGVufDB8fDB8fHww',
                        'blizzard',
                      ),
                      _buildMediaCard(
                        'Bonfire',
                        'Crackling',
                        'https://images.unsplash.com/photo-1625119161833-57f8a7009f7b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Ym9uZmlyZXxlbnwwfHwwfHx8MA%3D%3D',
                        'bonfire',
                      ),
                      _buildMediaCard(
                        'Thunder',
                        'Deep rumble',
                        'https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?w=300',
                        'thunder',
                      ),
                      _buildMediaCard(
                        'Forest',
                        'Daytime birds',
                        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300',
                        'forest',
                      ),
                      _buildMediaCard(
                        'Garden',
                        'Peaceful breeze',
                        'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=300',
                        'garden',
                      ),
                      _buildMediaCard(
                        'Heavy Rain 1',
                        'Tropical rain',
                        'https://images.unsplash.com/photo-1630574232726-fc3ea90637b8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8aGVhdnklMjByYWluJTIwaW4lMjBmb3Jlc3R8ZW58MHx8MHx8fDA%3D',
                        'heavy_rain_1',
                      ),
                      _buildMediaCard(
                        'Heavy Rain 2',
                        'City rain',
                        'https://images.unsplash.com/photo-1532203512255-3c9c9d666c50?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGhlYXZ5JTIwcmFpbnxlbnwwfHwwfHx8MA%3D%3D',
                        'heavy_rain_2',
                      ),
                      _buildMediaCard(
                        'Light Rain 1',
                        'Soft drizzle',
                        'https://images.unsplash.com/photo-1625726376374-1e6768c03ec0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGxpZ2h0JTIwcmFpbnxlbnwwfHwwfHx8MA%3D%3D',
                        'light_rain_1',
                      ),
                      _buildMediaCard(
                        'Light Rain 2',
                        'Rain on roof',
                        'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGlnaHQlMjByYWlufGVufDB8fDB8fHww',
                        'light_rain_2',
                      ),
                      _buildMediaCard(
                        'Night Forest',
                        'Crickets',
                        'https://images.unsplash.com/photo-1506475043624-3f8371a12b33?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fG5pZ2h0JTIwZm9yZXN0fGVufDB8fDB8fHww',
                        'night_forest',
                      ),
                      _buildMediaCard(
                        'Nightingale',
                        'Bird song',
                        'https://images.unsplash.com/photo-1598726668148-99946ef1cb42?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bmlnaHRpbmdhbGUlMjBpbiUyMG5pZ2h0fGVufDB8fDB8fHww',
                        'nightingale',
                      ),
                      _buildMediaCard(
                        'Ocean Waves',
                        'Tides',
                        'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=300',
                        'ocean_waves',
                      ),
                      _buildMediaCard(
                        'Pendulum',
                        'Steady ticking',
                        'https://images.unsplash.com/photo-1508962914676-134849a727f0?w=300',
                        'pendulum',
                      ),
                      _buildMediaCard(
                        'River Stream',
                        'Running water',
                        'https://images.unsplash.com/photo-1437333306198-0970d59404f1?w=300',
                        'river_stream',
                      ),
                      _buildMediaCard(
                        'Waterfall',
                        'Heavy flow',
                        'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=300',
                        'waterfall',
                      ),
                      _buildMediaCard(
                        'Wind 1',
                        'Soft wind',
                        'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=300',
                        'wind_1',
                      ),
                      _buildMediaCard(
                        'Wind 2',
                        'Howling wind',
                        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=300',
                        'wind_2',
                      ),
                    ]),

                  // STORIES SECTION
                  if (widget.mode != AudioHubTabMode.soundsOnly)
                    _buildMediaSection('Bedtime Stories', [
                      _buildMediaCard(
                        'The Midnight Train',
                        'Fantasy • 22 min',
                        'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=300',
                        '',
                        isStory: true,
                      ),
                      _buildMediaCard(
                        'Ocean\'s Whisper',
                        'Adventure • 35 min',
                        'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=300',
                        '',
                        isStory: true,
                      ),
                    ]),
                ],
              ),
            ),
            if (!widget.embedded) _buildMiniPlayerAndNav(),
          ],
        ),
      ),
    );
  }

  // --- HELPER BUILDERS ---

  Widget _buildHeader() {
    return Padding(
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Evening',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'What would you like to hear tonight?',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTagsRow() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('😌 Relax', isSelected: true),
          _buildCategoryChip('🌧️ Rainy'),
          _buildCategoryChip('🌲 Nature'),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return GestureDetector(
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
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ocean Dreams',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5 minutes',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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
    );
  }

  Widget _buildMediaCard(
    String title,
    String subtitle,
    String imgUrl,
    String soundFile, {
    bool isStory = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isStory && soundFile.isNotEmpty) _playNaturalSound(soundFile);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imgUrl,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  width: 150,
                  color: Colors.white10,
                  child: const Icon(Icons.broken_image, color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? themeColor : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  // --- PLACE THIS AT THE END OF THE CLASS ---

  Widget _buildMiniPlayerAndNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- SPOTIFY STYLE MINI PLAYER ---
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SleepPlayer()),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D29),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=100',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentlyPlaying == "None"
                              ? "Not Playing"
                              : _currentlyPlaying,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          "Sanctuary Audio",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;
                      return IconButton(
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () =>
                            playing ? _player.pause() : _player.play(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- NAVBAR ---
          Container(
            color: const Color(0xFF050814),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 'Home'),
                _buildNavItem(Icons.wifi_tethering, 'Audio', isSelected: true),
                _buildNavItem(Icons.bar_chart_rounded, 'Wellness'),
                _buildNavItem(Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? themeColor : Colors.grey, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? themeColor : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
} // This is the final closing brace of the State class
