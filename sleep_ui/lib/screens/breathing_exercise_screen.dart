import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/sanctuary_screen.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String phase = "Breathe In";

  bool isRunning = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.7,
      upperBound: 1.2,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          phase = "Breathe Out";
        });
        _controller.reverse();
      }

      if (status == AnimationStatus.dismissed) {
        setState(() {
          phase = "Breathe In";
        });
        _controller.forward();
      }
    });
  }

  void startBreathing() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    _controller.forward();

    _timer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        stopBreathing();
      },
    );
  }

  void stopBreathing() {
    _timer?.cancel();

    _controller.stop();

    setState(() {
      isRunning = false;
      phase = "Session Complete";
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030B1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              /// HEADER
              Row(
                children: [
IconButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, '/sanctuary');
  },
  icon: const Icon(
    Icons.arrow_back,
    color: Colors.white,
  ),
),
                  
                  Expanded(
                    child: Center(
                      child: Text(
                        "Breathing Exercise",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const Spacer(),

              /// BREATH TEXT
              Text(
  phase == "Breathe In"
      ? "Breathe in the quiet"
      : "Release and relax",
  textAlign: TextAlign.center,
  style: GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  ),
),

              const SizedBox(height: 50),

              /// ANIMATED CIRCLE
              AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _controller.value,
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: [
              Color(0xFFF9B43F), // Amber
              Color(0xFFE88B73), // Peach
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB74D).withOpacity(0.55),
              blurRadius: 70,
              spreadRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Text(
            phase == "Breathe In" ? "IN" : "OUT",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  },
),
              const SizedBox(height: 50),

              Text(
                "Inhale slowly through your nose\nand exhale gently through your mouth",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF131D34),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "4s Inhale • 4s Exhale",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),

              const Spacer(),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isRunning
                      ? stopBreathing
                      : startBreathing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B43F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    isRunning ? "Stop Session" : "Start Session",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}