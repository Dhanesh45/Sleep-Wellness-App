import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────────────────
// ENTRY
// ─────────────────────────────────────────────────────────
void main() => runApp(const SerenovaApp());

class SerenovaApp extends StatelessWidget {
  const SerenovaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenova – Sleep Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
      ),
      home: const SleepCalculatorScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────
const kBg      = Color(0xFF111827);
const kCard    = Color(0xFF1C2433);
const kCard2   = Color(0xFF1A2235);
const kGreen   = Color(0xFF4A7C6A);
const kGreenLt = Color(0xFF5E9E89);
const kGold    = Color(0xFFD4A017);
const kMuted   = Color(0xFF8A95A3);
const kBorder  = Color(0xFF2A3444);
const kNavBg   = Color(0xFF161F2E);
const kWhite   = Colors.white;

// ─────────────────────────────────────────────────────────
// SLEEP CALCULATOR SCREEN
// ─────────────────────────────────────────────────────────
class SleepCalculatorScreen extends StatefulWidget {
  const SleepCalculatorScreen({super.key});
  @override
  State<SleepCalculatorScreen> createState() => _SleepCalculatorScreenState();
}

class _SleepCalculatorScreenState extends State<SleepCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Wake-up time
  int _wakeHour   = 6;
  int _wakeMinute = 0;
  bool _isAm      = true;

  // Selected cycle index (0-based)
  int _selectedCycle = 1; // default = 5 cycles

  // Cycle options: each is (cycleCount, label for sleepTime)
  // 90 min per cycle; wake - (cycles * 90) min
  List<_CycleOption> get _cycles {
    final wakeMinTotal = (_isAm ? _wakeHour % 12 : (_wakeHour % 12) + 12) * 60 + _wakeMinute;
    return [4, 5, 6].map((c) {
      final sleepMinTotal = (wakeMinTotal - c * 90 + 1440) % 1440;
      final h = sleepMinTotal ~/ 60;
      final m = sleepMinTotal % 60;
      final ampm = h < 12 ? 'AM' : 'PM';
      final h12 = h % 12 == 0 ? 12 : h % 12;
      final mStr = m.toString().padLeft(2, '0');
      return _CycleOption(
        cycles: c,
        sleepTime: '$h12:$mStr $ampm',
        hours: (c * 90 / 60),
      );
    }).toList();
  }

  late AnimationController _ringCtrl;
  late Animation<double>   _ringAnim;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut);
    _ringCtrl.forward();
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  void _recalcRing() {
    _ringCtrl.reset();
    _ringCtrl.forward();
  }

  // ── Time picker dialog ───────────────────────────────────
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _isAm ? _wakeHour % 12 : (_wakeHour % 12) + 12,
        minute: _wakeMinute,
      ),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kGreen,
            surface: kCard,
            onSurface: kWhite,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _isAm       = picked.period == DayPeriod.am;
        _wakeHour   = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        _wakeMinute = picked.minute;
        _recalcRing();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide  = MediaQuery.of(context).size.width > 600;
    final cycles  = _cycles;
    final sel     = cycles[_selectedCycle];

    Widget body = Column(
      children: [
        // ── App bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _IconBtn(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () {},
              ),
              const Expanded(
                child: Center(
                  child: Text('Sleep Calculator',
                      style: TextStyle(
                          color: kWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 40), // balance
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24 : 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Question ──────────────────────────────────
                const Text('When do you want to wake up?',
                    style: TextStyle(color: kMuted, fontSize: 14)),
                const SizedBox(height: 16),

                // ── Time picker card ──────────────────────────
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 20),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kBorder, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hour
                        _TimeSegment(
                            value: _wakeHour.toString().padLeft(2, '0')),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(':',
                              style: TextStyle(
                                  color: kWhite,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                  height: 1.0)),
                        ),
                        // Minute
                        _TimeSegment(
                            value: _wakeMinute
                                .toString()
                                .padLeft(2, '0')),
                        const SizedBox(width: 12),
                        // AM/PM
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: ['AM', 'PM'].map((p) {
                            final active =
                                (_isAm && p == 'AM') ||
                                (!_isAm && p == 'PM');
                            return GestureDetector(
                              onTap: () => setState(() {
                                _isAm = p == 'AM';
                                _recalcRing();
                              }),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: active
                                      ? kCard2
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  border: Border.all(
                                      color: active
                                          ? kBorder
                                          : Colors.transparent),
                                ),
                                child: Text(p,
                                    style: TextStyle(
                                        color: active
                                            ? kWhite
                                            : kMuted,
                                        fontSize: 14,
                                        fontWeight: active
                                            ? FontWeight.w700
                                            : FontWeight.w400)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Ideal sleep cycles ────────────────────────
                const Text('IDEAL SLEEP CYCLES',
                    style: TextStyle(
                        color: kMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2)),
                const SizedBox(height: 12),

                Row(
                  children: List.generate(cycles.length, (i) {
                    final sel2 = i == _selectedCycle;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedCycle = i;
                          _recalcRing();
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: EdgeInsets.only(
                              right: i < cycles.length - 1 ? 10 : 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: sel2 ? kGreen : kCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color:
                                    sel2 ? kGreen : kBorder,
                                width: sel2 ? 1.5 : 0.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                cycles[i].cycles.toString(),
                                style: TextStyle(
                                    color: kWhite,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1),
                              ),
                              const SizedBox(height: 2),
                              Text('cycles',
                                  style: TextStyle(
                                      color: sel2
                                          ? kWhite.withOpacity(0.8)
                                          : kMuted,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('Sleep at',
                                  style: TextStyle(
                                      color: sel2
                                          ? kWhite.withOpacity(0.7)
                                          : kMuted,
                                      fontSize: 10)),
                              const SizedBox(height: 1),
                              Text(cycles[i].sleepTime,
                                  style: TextStyle(
                                      color: kWhite,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // ── Recommendation ring card ──────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      // Ring
                      AnimatedBuilder(
                        animation: _ringAnim,
                        builder: (_, __) => SizedBox(
                          width: 110,
                          height: 110,
                          child: CustomPaint(
                            painter: _RingPainter(
                              progress: _ringAnim.value,
                              hours: sel.hours,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${sel.hours % 1 == 0 ? sel.hours.toInt() : sel.hours} hrs',
                                    style: const TextStyle(
                                        color: kWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${sel.cycles} cycles',
                                    style: const TextStyle(
                                        color: kMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 22),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Recommended',
                                style: TextStyle(
                                    color: kGold,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            const Text('Sleep at',
                                style: TextStyle(
                                    color: kMuted, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(sel.sleepTime,
                                style: const TextStyle(
                                    color: kWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Calculate button ──────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calculate_outlined, size: 20),
                    label: const Text('Calculate Sleep Cycles',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: kWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Page links: Sleep Analyzer / Remedies ─────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/analyzer');
                        },
                        child: const Text('Sleep Analyzer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/remedy');
                        },
                        child: const Text('Remedies'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // ── Bottom Nav ───────────────────────────────────────
        const _BottomNav(selected: 1),
      ],
    );

    if (isWide) {
      return Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: body,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(child: body),
    );
  }
}

// ─────────────────────────────────────────────────────────
// DATA CLASS
// ─────────────────────────────────────────────────────────
class _CycleOption {
  final int cycles;
  final String sleepTime;
  final double hours;
  const _CycleOption(
      {required this.cycles,
      required this.sleepTime,
      required this.hours});
}

// ─────────────────────────────────────────────────────────
// RING PAINTER
// ─────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final double hours;
  const _RingPainter({required this.progress, required this.hours});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.width / 2) - 8;
    const strokeW = 10.0;

    // Track
    final trackPaint = Paint()
      ..color = kBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    // Arc — max 8 hrs = full circle
    final fraction = (hours / 8.0).clamp(0.0, 1.0) * progress;
    final arcPaint = Paint()
      ..color = kGreenLt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.hours != hours;
}

// ─────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────
class _TimeSegment extends StatelessWidget {
  final String value;
  const _TimeSegment({required this.value});
  @override
  Widget build(BuildContext context) {
    return Text(value,
        style: const TextStyle(
            color: kWhite,
            fontSize: 52,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.0));
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Icon(icon, color: kWhite, size: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selected;
  const _BottomNav({required this.selected});

  static const _items = [
    (Icons.home_rounded,              'HOME'),
    (Icons.bedtime_rounded,           'SLEEP'),
    (Icons.self_improvement_rounded,  'CALM'),
    (Icons.auto_stories_rounded,      'STORIES'),
    (Icons.person_outline_rounded,    'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kNavBg,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final sel = selected == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? kGreen.withOpacity(0.18) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_items[i].$1,
                    color: sel ? kGreenLt : kMuted, size: 22),
                const SizedBox(height: 3),
                Text(_items[i].$2,
                    style: TextStyle(
                        color: sel ? kGreenLt : kMuted,
                        fontSize: 9,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.w400,
                        letterSpacing: 0.5)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
