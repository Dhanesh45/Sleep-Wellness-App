import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SleepPlayer extends StatefulWidget {
  const SleepPlayer({Key? key}) : super(key: key);

  @override
  State<SleepPlayer> createState() => _SleepPlayerState();
}

class _SleepPlayerState extends State<SleepPlayer> {
  // Audio Players for the main music and layered ambient elements
  late AudioPlayer _musicPlayer;
  late AudioPlayer _rainPlayer;
  late AudioPlayer _windPlayer;
  late AudioPlayer _thunderPlayer;

  bool isPlaying = false;
  double rainValue = 0.65;
  double windValue = 0.20;
  double thunderValue = 0.05;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayers();
  }

  Future<void> _initializeAudioPlayers() async {
    _musicPlayer = AudioPlayer();
    _rainPlayer = AudioPlayer();
    _windPlayer = AudioPlayer();
    _thunderPlayer = AudioPlayer();

    try {
      // Load the main music track and ambient layers from assets
      await _musicPlayer.setAsset('assets/sounds/ocean dreams.mp3');
      await _rainPlayer.setAsset('assets/sounds/ocean dreams.mp3');
      await _windPlayer.setAsset('assets/sounds/ocean dreams.mp3');
      await _thunderPlayer.setAsset('assets/sounds/ocean dreams.mp3');

      // Enable infinite looping for all tracks so playback doesn't abruptly stop
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _rainPlayer.setLoopMode(LoopMode.one);
      await _windPlayer.setLoopMode(LoopMode.one);
      await _thunderPlayer.setLoopMode(LoopMode.one);

      // Set initial volumes
      await _musicPlayer.setVolume(1.0); // Main music plays at full volume
      await _rainPlayer.setVolume(rainValue);
      await _windPlayer.setVolume(windValue);
      await _thunderPlayer.setVolume(thunderValue);
    } catch (e) {
      debugPrint("Error loading audio assets: $e");
    }
  }

  // Master playback controller for all tracks
  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _musicPlayer.play();
      _rainPlayer.play();
      _windPlayer.play();
      _thunderPlayer.play();
    } else {
      _musicPlayer.pause();
      _rainPlayer.pause();
      _windPlayer.pause();
      _thunderPlayer.pause();
    }
  }

  @override
  void dispose() {
    // Clean up resources when leaving the player screen to prevent memory leaks
    _musicPlayer.dispose();
    _rainPlayer.dispose();
    _windPlayer.dispose();
    _thunderPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFFCD3A1);

    return Scaffold(
      backgroundColor: const Color(0xFF090C10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text(
              'NOW PLAYING',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Ocean Dreams',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // High-fidelity Main Cover Art Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Track details header
            Text(
              'Ocean Dreams',
              style: TextStyle(
                color: themeColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Deep Sleep Collection • 45m',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Recommendation Inline Widget Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: themeColor, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'SleepMate: Try adding 20% Rain for today\'s recovery',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline Track Progression Interface
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 0,
                    ), // Flat clean tracking visual bar
                    activeTrackColor: themeColor,
                    inactiveTrackColor: Colors.white10,
                  ),
                  child: Slider(value: 0.35, onChanged: (v) {}),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '15:02',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        '29:58',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main Audio Control Deck Layout structure
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.skip_previous, color: Colors.white, size: 28),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: _togglePlayback,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: themeColor,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                const Icon(Icons.skip_next, color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 32),

            // Modular Feature Quick Grid Layout
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    'Timer',
                    '30m\nRemaining',
                    Icons.access_time,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    'Mixer',
                    'Active\nLayers',
                    Icons.tune,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Continuous Sound Architecture Mixers Block
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nature Layers',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildAmbientSlider('Rain', Icons.water_drop, rainValue, (v) {
              setState(() => rainValue = v);
              _rainPlayer.setVolume(v);
            }),
            _buildAmbientSlider('Wind', Icons.air, windValue, (v) {
              setState(() => windValue = v);
              _windPlayer.setVolume(v);
            }),
            _buildAmbientSlider('Thunder', Icons.flash_on, thunderValue, (v) {
              setState(() => thunderValue = v);
              _thunderPlayer.setVolume(v);
            }),

            const SizedBox(height: 24),
            // Footer Control Action Triggers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFooterAction(Icons.favorite_border, 'Save'),
                _buildFooterAction(
                  Icons.download_for_offline_outlined,
                  'Offline',
                ),
                _buildFooterAction(Icons.sync, 'Loop'),
                _buildFooterAction(Icons.share_outlined, 'Share'),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFCD3A1), size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientSlider(
    String element,
    IconData icon,
    double currentVal,
    ValueChanged<double> onChange,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      element,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '${(currentVal * 100).toInt()}%',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFFCD3A1),
                    inactiveTrackColor: Colors.white10,
                    thumbColor: const Color(0xFFFCD3A1),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: currentVal,
                    min: 0,
                    max: 1,
                    onChanged: onChange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}
