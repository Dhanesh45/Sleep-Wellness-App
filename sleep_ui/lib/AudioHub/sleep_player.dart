import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SleepPlayer extends StatefulWidget {
  final String title;
  final String assetPath;
  final String imageUrl;
  final String? audioUrl;

  const SleepPlayer({
    Key? key,
    this.title = 'Ocean Dreams',
    this.assetPath = 'assets/sounds/ocean dreams.mp3',
    this.imageUrl =
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
    this.audioUrl,
  }) : super(key: key);

  @override
  State<SleepPlayer> createState() => _SleepPlayerState();
}

class _SleepPlayerState extends State<SleepPlayer> {
  late AudioPlayer _musicPlayer;

  bool isPlaying = false;
  bool isLooping = true;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayers();
  }

  Future<void> _initializeAudioPlayers() async {
    _musicPlayer = AudioPlayer();

    try {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        await _musicPlayer.setUrl(widget.audioUrl!);
      } else {
        await _musicPlayer.setAsset(widget.assetPath);
      }

      _musicPlayer.durationStream.listen(
        (d) => setState(() => _duration = d ?? Duration.zero),
      );

      _musicPlayer.positionStream.listen((p) => setState(() => _position = p));

      _setAllLoopModes(isLooping);

      await _musicPlayer.setVolume(1.0);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _setAllLoopModes(bool loop) {
    LoopMode mode = loop ? LoopMode.one : LoopMode.off;
    _musicPlayer.setLoopMode(mode);
  }

  void _toggleLoop() {
    setState(() => isLooping = !isLooping);
    _setAllLoopModes(isLooping);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _togglePlayback() {
    setState(() => isPlaying = !isPlaying);
    if (isPlaying) {
      _musicPlayer.play();
    } else {
      _musicPlayer.pause();
    }
  }

  @override
  void dispose() {
    _musicPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFFB923C);

    return Scaffold(
      backgroundColor: const Color(0xFF090C10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'NOW PLAYING',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  widget.imageUrl,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: TextStyle(
                color: themeColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Deep Sleep Collection',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                activeTrackColor: themeColor,
                inactiveTrackColor: Colors.white10,
                thumbColor: themeColor,
              ),
              child: Slider(
                value: _position.inMilliseconds.toDouble(),
                min: 0.0,
                max: _duration.inMilliseconds.toDouble() > 0
                    ? _duration.inMilliseconds.toDouble()
                    : 1.0,
                onChanged: (value) =>
                    _musicPlayer.seek(Duration(milliseconds: value.toInt())),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isLooping ? Icons.repeat_one : Icons.repeat,
                    color: isLooping ? themeColor : Colors.white54,
                  ),
                  onPressed: _toggleLoop,
                ),
                const SizedBox(width: 16),
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
                const SizedBox(width: 16),
                const Icon(Icons.shuffle, color: Colors.white54, size: 24),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
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
}
