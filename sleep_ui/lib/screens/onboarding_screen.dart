import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────
void main() => runApp(const SerenovaApp());

class SerenovaApp extends StatelessWidget {
  const SerenovaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ONBOARDING SCREEN
// ─────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Orb breathing glow
  late AnimationController _orbCtrl;
  late Animation<double> _glow;

  // Initial fade-in
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  // Floating star twinkle
  late AnimationController _starCtrl;
  late Animation<double> _starOpacity;

  // ── Fixed star data: {dx, dy} as fractions of orb-area ──
  static const _stars = [
    _Star(fx: 0.10, fy: 0.38, size: 4),   // left mid
    _Star(fx: 0.82, fy: 0.22, size: 3),   // right upper
    _Star(fx: 0.88, fy: 0.60, size: 3),   // right lower
  ];

  @override
  void initState() {
    super.initState();

    _orbCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.65, end: 1.0).animate(
        CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut));

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _starCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat(reverse: true);
    _starOpacity = Tween<double>(begin: 0.3, end: 0.9).animate(
        CurvedAnimation(parent: _starCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    _fadeCtrl.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final isWide = mq.size.width > 600;

    // On wide screens centre-constrain to phone width
    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFF111827),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: _buildContent(context, isWide: false),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: _buildContent(context, isWide: false),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isWide}) {
    return FadeTransition(
      opacity: _fade,
      child: Column(
        children: [
          // ── TOP: orb area, fills ~55 % of screen ──────────
          Expanded(
            flex: 55,
            child: _OrbArea(
              glow: _glow,
              starOpacity: _starOpacity,
              stars: _stars,
            ),
          ),

          // ── BOTTOM: dark card ──────────────────────────────
          Expanded(
            flex: 45,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1C2433),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step indicator
                  const Text(
                    '1 of 3',
                    style: TextStyle(
                      color: Color(0xFF8A95A3),
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Headline
                  const Text(
                    'Sleep better,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Body copy
                  const Text(
                    'Serenova gently guides you to restful sleep '
                    'through calming sounds, stories, and personal '
                    'sleep insights.',
                    style: TextStyle(
                      color: Color(0xFF8A95A3),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      height: 1.65,
                    ),
                  ),

                  const Spacer(),

                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A7C6A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Begin Your Journey',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Color(0xFF8A95A3),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ORB AREA WIDGET
// ─────────────────────────────────────────────────────────
class _OrbArea extends StatelessWidget {
  final Animation<double> glow;
  final Animation<double> starOpacity;
  final List<_Star> stars;

  const _OrbArea({
    required this.glow,
    required this.starOpacity,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final w = box.maxWidth;
      final h = box.maxHeight;
      final orbSize = w * 0.42; // ~42 % of width, like the screenshot

      return Stack(
        children: [
          // Stars
          ...stars.map((s) => Positioned(
                left: w * s.fx,
                top:  h * s.fy,
                child: AnimatedBuilder(
                  animation: starOpacity,
                  builder: (_, _) => Container(
                    width:  s.size.toDouble(),
                    height: s.size.toDouble(),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: starOpacity.value),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.white.withValues(alpha: starOpacity.value * 0.5),
                          blurRadius: 5,
                        )
                      ],
                    ),
                  ),
                ),
              )),

          // Orb + glow
          Center(
            child: AnimatedBuilder(
              animation: glow,
              builder: (_, _) => Container(
                width:  orbSize * 1.75,
                height: orbSize * 1.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4A017)
                          .withValues(alpha: 0.22 * glow.value),
                      blurRadius: orbSize * 0.9,
                      spreadRadius: orbSize * 0.22,
                    ),
                    BoxShadow(
                      color: const Color(0xFFF5C842)
                          .withValues(alpha: 0.09 * glow.value),
                      blurRadius: orbSize * 1.7,
                      spreadRadius: orbSize * 0.55,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width:  orbSize,
                    height: orbSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: Alignment(-0.28, -0.32),
                        radius: 0.72,
                        colors: [
                          Color(0xFFF8D060),
                          Color(0xFFD4A017),
                          Color(0xFF9A7010),
                        ],
                        stops: [0.0, 0.52, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────
// STAR DATA CLASS
// ─────────────────────────────────────────────────────────
class _Star {
  final double fx;   // fraction of area width
  final double fy;   // fraction of area height
  final int    size; // diameter in px
  const _Star({required this.fx, required this.fy, required this.size});
}
