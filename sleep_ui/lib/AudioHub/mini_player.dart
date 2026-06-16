import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayer player;
  final String currentTrack;
  final VoidCallback onTap;

  const MiniPlayer({
    Key? key,
    required this.player,
    required this.currentTrack,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentTrack == "None") {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D29),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 45,
                height: 45,
                color: const Color(0xFFFB923C),
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTrack,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    "Natural Sounds",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;

                return IconButton(
                  icon: Icon(
                    playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: const Color(0xFFFB923C),
                    size: 34,
                  ),
                  onPressed: () {
                    if (playing) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
