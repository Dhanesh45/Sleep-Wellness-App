import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DeepSleepAudioPlayer extends StatefulWidget {
  const DeepSleepAudioPlayer({super.key});

  static const String routeName = 'DeepSleepAudioPlayer';
  static const String routePath = '/deepSleepAudioPlayer';

  @override
  State<DeepSleepAudioPlayer> createState() =>
      _DeepSleepAudioPlayerWidgetState();
}

class _DeepSleepAudioPlayerWidgetState extends State<DeepSleepAudioPlayer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // State Variables to replace FlutterFlow AppState / Models
  bool _isPlaying = true;
  double _sliderValue = 35.0;
  String _selectedTimer = '30m';

  // Dummy data representing the original AudioTracksRecord stream
  final String _trackTitle = 'Starlit Forest Whispers';
  final String _trackCategory = 'Bedtime Stories';
  final String _trackLanguage = 'English';

  // Theme Color Fallbacks (Simulating the deep sleep FlutterFlow theme)
  final Color _primaryBackground = const Color(0xFF0D0D15);
  final Color _primaryText = Colors.white;
  final Color _secondaryText = const Color(0xFF9E9E9E); // Colors.grey[500]
  final Color _primaryColor = const Color(0xFF5E35B1); // Deep Purple
  final Color _primary20 = const Color(0x335E35B1);
  final Color _accent20 = const Color(0x33B39DDB);
  final Color _primaryText80 = Colors.white.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _primaryBackground,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Top App Bar Area ---
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 28,
                    icon: Icon(
                      Icons.expand_more_rounded,
                      color: _secondaryText,
                    ),
                    onPressed: () async {
                      // TODO: Implement pop navigation
                      Navigator.of(context).pop();
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _trackTitle,
                        style: GoogleFonts.nunito(
                          color: _primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_trackCategory • $_trackLanguage',
                        style: GoogleFonts.quicksand(
                          color: _secondaryText,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    iconSize: 24,
                    icon: Icon(
                      Icons.favorite_border_rounded,
                      color: _secondaryText,
                    ),
                    onPressed: () {
                      // TODO: Implement favorite action
                    },
                  ),
                ],
              ),

              const Spacer(),

              // --- Center Animation & Artwork Stack ---
              SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.network(
                      'https://dimg.dreamflow.cloud/v1/lottie/slowly+expanding+and+contracting+glowing+amber+ring+aura',
                      width: 320,
                      height: 320,
                      fit: BoxFit.contain,
                      animate: _isPlaying,
                    ),
                    ClipRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _accent20,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            color: _primary20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          imageUrl:
                              'https://dimg.dreamflow.cloud/v1/image/soft%20focus%20atmospheric%20orange%20and%20deep%20purple%20nebula%20gradient',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.8),
                      child: Text(
                        'Breathe in the quiet',
                        style: GoogleFonts.nunito(
                          color: _primaryText80,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // --- Slider & Timestamps ---
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      activeColor: _primaryColor,
                      inactiveColor: _primary20,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        // TODO: Implement seek logic
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '12:45',
                        style: GoogleFonts.quicksand(
                          color: _secondaryText,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '45:00',
                        style: GoogleFonts.quicksand(
                          color: _secondaryText,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- Media Controls ---
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 32,
                    icon: Icon(
                      Icons
                          .fast_rewind_rounded, // Replaced placeholder Icons.help
                      color: _primaryText,
                    ),
                    onPressed: () {
                      // TODO: Implement previous track / rewind
                    },
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(9999),
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      // TODO: Implement play/pause playback logic
                    },
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons
                                  .play_arrow_rounded, // Replaced placeholder Icons.help
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: Icon(
                      Icons
                          .fast_forward_rounded, // Replaced placeholder Icons.help
                      color: _primaryText,
                    ),
                    onPressed: () {
                      // TODO: Implement next track / fast forward
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- Sleep Timer ---
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sleep Timer',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      color: _secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTimerChip('15m'),
                        const SizedBox(width: 8),
                        _buildTimerChip('30m'),
                        const SizedBox(width: 8),
                        _buildTimerChip('1h'),
                        const SizedBox(width: 8),
                        _buildTimerChip('End of Track'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to replace the custom TimerChipWidget
  Widget _buildTimerChip(String label) {
    final bool isSelected = _selectedTimer == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) _selectedTimer = label;
        });
        // TODO: Implement timer backend logic
      },
      labelStyle: GoogleFonts.quicksand(
        color: isSelected ? Colors.white : _secondaryText,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: _primaryColor.withOpacity(0.4),
      side: BorderSide(
        color: isSelected ? _primaryColor : _secondaryText.withOpacity(0.3),
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
