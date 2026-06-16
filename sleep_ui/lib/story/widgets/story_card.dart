import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/story/models/story_template.dart';

class StoryCard extends StatelessWidget {
  final StoryTemplate story;
  final VoidCallback? onTap;

  const StoryCard({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine image widget type
    final Widget imageWidget;
    final String? path = story.thumbnailPath;
    if (path != null && path.startsWith('assets/')) {
      imageWidget = Image.asset(
        path,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 160,
          color: const Color(0xFF1F2937),
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    } else if (path != null && path.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: path,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 160,
          color: const Color(0xFF1F2937),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB03A)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 160,
          color: const Color(0xFF1F2937),
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    } else {
      // Default local asset placeholder
      imageWidget = Image.asset(
        'assets/images/ravenstorytb.png',
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 160,
          color: const Color(0xFF1F2937),
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827), // Dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1F2937), // Subtle border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image & Badge Stack
            Stack(
              children: [
                imageWidget,
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Duration Badge UI
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white24,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFFFFB03A), // Accent yellow
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${story.durationMinutes} mins',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Text Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    story.description,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF9CA3AF), // Muted text
                      fontSize: 13,
                      height: 1.4,
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
}
