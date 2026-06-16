import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/voice_mode_screen.dart';
import 'package:sleep_ui/SleepHub/dashboard_screen.dart';
import 'package:sleep_ui/AudioHub/sleep_dashboard.dart';
import 'package:sleep_ui/story/screens/stories_screen.dart';

class SanctuaryHomePage extends StatefulWidget {
  const SanctuaryHomePage({super.key});

  static const String routeName = 'SanctuaryHomePage';
  static const String routePath = '/sanctuaryHome';

  @override
  State<SanctuaryHomePage> createState() => _SanctuaryHomePageState();
}

class _SanctuaryHomePageState extends State<SanctuaryHomePage> {
  // Theme
  final Color _primaryBackground = const Color(0xFF050814);
  final Color _cardBackground = const Color(0xFF111827);
  final Color _primaryText = Colors.white;
  final Color _secondaryText = const Color(0xFF9CA3AF);
  final Color _accentYellow = const Color(0xFFFB923C);
  final Color _accentOrange = const Color(0xFFFB923C);
  final Color _accentPink = const Color(0xFFFB7185);
  final Color _accentBlue = const Color(0xFF38BDF8);

  int _selectedBottomIndex = 0;

  // Sleep chart dummy values (Mon–Sun)
  final List<double> _sleepValues = const [4.5, 6, 7, 6.5, 8, 7.2, 6.8];

  @override
  Widget build(BuildContext context) {
    Widget activeTab;
    switch (_selectedBottomIndex) {
      case 0:
        activeTab = _buildHomeTab();
        break;
      case 1:
        activeTab = const DashboardScreen();
        break;
      case 2:
        activeTab = const StoriesScreen();
        break;
      case 3:
        activeTab = const SleepDashboard(
          embedded: true,
          mode: AudioHubTabMode.soundsOnly,
        );
        break;
      case 4:
        activeTab = _buildRemedialTab();
        break;
      default:
        activeTab = _buildHomeTab();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _primaryBackground,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: activeTab),
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: _buildBottomNavPill(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ).copyWith(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingHeader(),
          const SizedBox(height: 24),
          _buildSanctuaryCard(),
          const SizedBox(height: 20),
          _buildSleepConsistencyCard(),
          const SizedBox(height: 20),
          _buildAudioZoneRow(),
          const SizedBox(height: 24),
          _buildSectionHeader(title: 'Soothing Sounds', action: 'See All'),
          const SizedBox(height: 16),
          _buildSoothingSoundsList(),
          const SizedBox(height: 24),
          _buildSectionHeader(
            title: 'Natural Remedies',
            trailingIcon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 16),
          _buildRemedyCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRemedialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ).copyWith(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Natural Remedies',
            style: GoogleFonts.nunito(
              color: _primaryText,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Holistic recipes and routines to calm your nervous system.',
            style: GoogleFonts.quicksand(color: _secondaryText, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildRemedyCard(),
          const SizedBox(height: 16),
          _buildRemedyCardItem(
            title: 'Chamomile & Lavender Tea',
            imageUrl:
                'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg',
            description:
                'A classic floral blend that triggers GABA receptors in the brain to reduce anxiety and promote sleepiness.',
            time: '5 min',
          ),
          const SizedBox(height: 16),
          _buildRemedyCardItem(
            title: 'Warm Nutmeg Milk',
            imageUrl:
                'https://images.pexels.com/photos/5946609/pexels-photo-5946609.jpeg',
            description:
                'Nutmeg is rich in myristicin, which acts as a natural sedative. Best taken 30 minutes before bed.',
            time: '8 min',
          ),
        ],
      ),
    );
  }

  Widget _buildRemedyCardItem({
    required String title,
    required String imageUrl,
    required String description,
    required String time,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: CachedNetworkImage(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              imageUrl: imageUrl,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: _primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.quicksand(
                    color: _secondaryText,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.black.withOpacity(0.24),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_rounded,
                            size: 14,
                            color: _secondaryText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: GoogleFonts.quicksand(
                              color: _secondaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: _accentYellow.withOpacity(0.16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Read Recipe',
                            style: GoogleFonts.quicksand(
                              color: _accentYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: _accentYellow,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- TOP HEADER --------------------

  Widget _buildGreetingHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening,',
                style: GoogleFonts.nunito(
                  color: _primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The world is quiet now.',
                style: GoogleFonts.quicksand(
                  color: _secondaryText.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------- SANCTUARY CARD --------------------

  Widget _buildSanctuaryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VoiceModeScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF111827), Color(0xFF020617)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRect(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _accentOrange.withOpacity(0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Lottie.asset(
                    'assets/lottie/campfire.json',
                    width: 280,
                    height: 280,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            Text(
              'Your sanctuary is warm',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: _primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.32),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_rounded, size: 16, color: _accentBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Shield Active',
                    style: GoogleFonts.quicksand(
                      color: _primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to talk with SleepMate',
              style: GoogleFonts.quicksand(
                color: _accentYellow,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- SLEEP CONSISTENCY --------------------

  Widget _buildSleepConsistencyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: _cardBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sleep Consistency',
                style: GoogleFonts.nunito(
                  color: _primaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '7h 12m avg',
                style: GoogleFonts.quicksand(
                  color: _accentYellow,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 72,
            child: CustomPaint(
              painter: _SleepChartPainter(
                values: _sleepValues,
                lineColor: _accentYellow,
                dotColor: _accentYellow,
                backgroundLineColor: Colors.white.withOpacity(0.05),
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You spent 7 hours resting your mind last night.',
            style: GoogleFonts.quicksand(color: _secondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // -------------------- AUDIO ZONE + CALM REGION --------------------

  Widget _buildAudioZoneRow() {
    return Row(
      children: [
        Expanded(
          child: _buildRoundedBlobCard(
            title: 'Audio Zone',
            subtitle: 'Vibes & Sounds',
            icon: Icons.graphic_eq_rounded,
            colors: const [Color(0xFF5F431A), Color(0xFF2A1B07)],
            onTap: () {
              setState(() => _selectedBottomIndex = 3);
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildRoundedBlobCard(
            title: 'Remedial',
            subtitle: 'Recipes & Zen',
            icon: Icons.spa_rounded,
            colors: const [Color(0xFF5A1818), Color(0xFF280707)],
            onTap: () {
              setState(() => _selectedBottomIndex = 4);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoundedBlobCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
    Alignment glowAlignment = Alignment.centerRight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Positioned(
                right: 14,
                top: 10,
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 16,
                child: Icon(icon, color: _accentYellow, size: 21),
              ),
              Positioned(
                left: 18,
                right: 18,
                top: 46,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.0,
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                top: 67,
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // -------------------- SECTION HEADER --------------------

  Widget _buildSectionHeader({
    required String title,
    String? action,
    IconData? trailingIcon,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            color: _primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, color: _accentYellow, size: 18),
        ],
        const Spacer(),
        if (action != null)
          Text(
            action,
            style: GoogleFonts.quicksand(
              color: _accentYellow,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  // -------------------- SOOTHING SOUNDS LIST --------------------

  Widget _buildSoothingSoundsList() {
    final List<String> items = [
      'Rain on Tin Roof',
      'Forest Night Drift',
      'Soft City Showers',
    ];

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _buildSoundCard(items[index]);
        },
      ),
    );
  }

  Widget _buildSoundCard(String title) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: CachedNetworkImage(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              imageUrl:
                  'https://images.pexels.com/photos/34088/pexels-photo.jpg',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ).copyWith(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: _primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Overnight',
                  style: GoogleFonts.quicksand(
                    color: _secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- REMEDY CARD --------------------

  Widget _buildRemedyCard() {
    return _buildRemedyCardItem(
      title: 'Ashwagandha Tonic',
      imageUrl:
          'https://images.pexels.com/photos/3735631/pexels-photo-3735631.jpeg',
      description:
          "Known as 'Winter Cherry', this adaptogen helps the body manage stress and cortisol levels for deeper REM sleep.",
      time: '10 min',
    );
  }

  // -------------------- BOTTOM NAV PILL --------------------

  Widget _buildBottomNavPill() {
    final items = [
      _BottomNavItem(Icons.home_rounded, 'Home'),
      _BottomNavItem(Icons.bedtime_rounded, 'Sleep'),
      _BottomNavItem(Icons.auto_stories_rounded, 'Stories'),
      _BottomNavItem(Icons.graphic_eq_rounded, 'Sounds'),
      _BottomNavItem(Icons.spa_rounded, 'Remedial'),
    ];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            items.length,
            (index) => _buildBottomNavChip(items[index], index),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavChip(_BottomNavItem item, int index) {
    final bool selected = index == _selectedBottomIndex;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedBottomIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _accentYellow.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 18,
              color: selected ? _accentYellow : _secondaryText,
            ),
            const SizedBox(width: 6),
            if (selected)
              Text(
                item.label,
                style: GoogleFonts.quicksand(
                  color: _accentYellow,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// -------------------- HELPERS --------------------

class _BottomNavItem {
  final IconData icon;
  final String label;
  const _BottomNavItem(this.icon, this.label);
}

class _SleepChartPainter extends CustomPainter {
  _SleepChartPainter({
    required this.values,
    required this.lineColor,
    required this.dotColor,
    required this.backgroundLineColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color dotColor;
  final Color backgroundLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const double minH = 4;
    const double maxH = 9;
    final double baselineY = size.height * 0.76;

    // 1. Draw horizontal gridlines (faint guides)
    final Paint gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.22),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.49),
      Offset(size.width, size.height * 0.49),
      gridPaint,
    );

    // Baseline guide
    final Paint bgPaint = Paint()
      ..color = backgroundLineColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      bgPaint,
    );

    if (values.isEmpty) return;

    final double stepX = values.length > 1
        ? size.width / (values.length - 1)
        : 0;

    // Generate data points
    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final double t = (values[i] - minH) / (maxH - minH);
      final double x = stepX * i;
      final double y = baselineY - (t * size.height * 0.58);
      points.add(Offset(x, y));
    }

    // 2. Generate smooth curve path
    final Path curvePath = Path();
    if (points.isNotEmpty) {
      curvePath.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final Offset p1 = points[i];
        final Offset p2 = points[i + 1];
        final double controlX = p1.dx + (p2.dx - p1.dx) / 2;
        curvePath.cubicTo(controlX, p1.dy, controlX, p2.dy, p2.dx, p2.dy);
      }
    }

    // 3. Draw gradient area fill under the curve
    if (points.isNotEmpty) {
      final Path fillPath = Path.from(curvePath);
      fillPath.lineTo(points.last.dx, baselineY);
      fillPath.lineTo(points.first.dx, baselineY);
      fillPath.close();

      final Paint fillPaint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lineColor.withOpacity(0.18),
                lineColor.withOpacity(0.00),
              ],
            ).createShader(
              Rect.fromLTRB(0, size.height * 0.1, size.width, baselineY),
            )
        ..style = PaintingStyle.fill;
      canvas.drawPath(fillPath, fillPaint);
    }

    // 4. Draw main smooth curve stroke
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(curvePath, linePaint);

    // 5. Draw glowing data points
    final Paint outerDotPaint = Paint()
      ..color = dotColor.withOpacity(0.24)
      ..style = PaintingStyle.fill;
    final Paint innerDotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (final Offset pt in points) {
      canvas.drawCircle(pt, 5.5, outerDotPaint);
      canvas.drawCircle(pt, 2.5, innerDotPaint);
    }

    // 6. Weekday labels at the bottom
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final textStyle = TextStyle(
      color: lineColor.withOpacity(0.35),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    final double labelY = size.height - 5;

    for (int i = 0; i < days.length && i < values.length; i++) {
      final double x = stepX * i;
      final TextPainter tp = TextPainter(
        text: TextSpan(text: days[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, labelY - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _SleepChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.backgroundLineColor != backgroundLineColor;
  }
}
