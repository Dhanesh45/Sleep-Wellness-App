import 'package:flutter/material.dart';

void main() {
  runApp(const SerenovaApp());
}

class SerenovaApp extends StatelessWidget {
  const SerenovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4A017),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _glowPulse;

  int _currentDot = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Cycle dots for demo
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _currentDot = 1);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _currentDot = 2);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 600;
            final double orbSize = isWide ? 160 : 110;

            return Column(
              children: [
                // ── Main content centered ──
                Expanded(
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Glowing orb
                          AnimatedBuilder(
                            animation: _glowPulse,
                            builder: (context, child) {
                              return Container(
                                width: orbSize * 1.6,
                                height: orbSize * 1.6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD4A017)
                                          .withValues(alpha: 0.18 * _glowPulse.value),
                                      blurRadius: orbSize * 0.8,
                                      spreadRadius: orbSize * 0.3,
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFE8B84B)
                                         .withValues(alpha: 0.10 * _glowPulse.value),
                                      blurRadius: orbSize * 1.4,
                                      spreadRadius: orbSize * 0.5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: orbSize,
                                    height: orbSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        center: const Alignment(-0.3, -0.3),
                                        radius: 0.75,
                                        colors: [
                                          const Color(0xFFF5C842),
                                          const Color(0xFFD4A017),
                                          const Color(0xFFA07010),
                                        ],
                                        stops: const [0.0, 0.55, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: isWide ? 48 : 36),

                          // App name
                          Text(
                            'Serenova',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWide ? 42 : 32,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Tagline
                          Text(
                            'Your gentle sleep companion',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: isWide ? 16 : 14,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Page indicator dots ──
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final bool active = i == _currentDot;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFD4A017)
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}