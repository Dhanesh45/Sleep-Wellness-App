import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// ENTRY
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
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// TOKENS
// ─────────────────────────────────────────────────────────
const kBg        = Color(0xFF111827);
const kCard      = Color(0xFF1C2433);
const kCard2     = Color(0xFF1A2235);
const kGreen     = Color(0xFF4A7C6A);
const kGreenLt   = Color(0xFF5E9E89);
const kGold      = Color(0xFFD4A017);
const kGoldLt    = Color(0xFFF5C842);
const kMuted     = Color(0xFF8A95A3);
const kBorder    = Color(0xFF2A3444);
const kNavBg     = Color(0xFF161F2E);

// ─────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIdx = 0;

  late AnimationController _fadeCtrl;
  late Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Nav items ───────────────────────────────────────────
  static const _navItems = [
    _NavItem(icon: Icons.home_rounded,           label: 'HOME'),
    _NavItem(icon: Icons.bedtime_rounded,         label: 'SLEEP'),
    _NavItem(icon: Icons.self_improvement_rounded,label: 'CALM'),
    _NavItem(icon: Icons.auto_stories_rounded,    label: 'STORIES'),
    _NavItem(icon: Icons.person_outline_rounded,  label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget content = FadeTransition(
      opacity: _fade,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Header(),
                  SizedBox(height: 20),
                  _SleepScoreCard(),
                  SizedBox(height: 14),
                  _MoodCard(),
                  SizedBox(height: 20),
                  _QuickAccessSection(),
                  SizedBox(height: 20),
                  _SleepTrendSection(),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _BottomNav(
            items: _navItems,
            selected: _navIdx,
            onTap: (i) => setState(() => _navIdx = i),
          ),
        ],
      ),
    );

    if (isWide) {
      return Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: content,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(child: content),
    );
  }
}

// ─────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good Evening',
                style: TextStyle(color: kMuted, fontSize: 13)),
            const SizedBox(height: 2),
            const Text('Arjun',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.1)),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// SLEEP SCORE CARD
// ─────────────────────────────────────────────────────────
class _SleepScoreCard extends StatelessWidget {
  const _SleepScoreCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sleep Score',
                    style: TextStyle(color: kMuted, fontSize: 13)),
                const SizedBox(height: 6),
                const Text('82',
                    style: TextStyle(
                        color: kGold,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        height: 1.0)),
                const SizedBox(height: 8),
                const Text('Good sleep last night',
                    style: TextStyle(color: kMuted, fontSize: 13)),
              ],
            ),
          ),
          // Right: bedtime chip
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kCard2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorder, width: 0.5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.nightlight_round,
                        color: kGreenLt, size: 15),
                    SizedBox(width: 6),
                    Text('10:30 PM',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('Recommended',
                  style: TextStyle(color: kMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MOOD CARD
// ─────────────────────────────────────────────────────────
class _MoodCard extends StatefulWidget {
  const _MoodCard();
  @override
  State<_MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<_MoodCard> {
  int? _selected;
  final _moods = const ['😴', '😐', '😊', '🌿'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('How do you feel tonight?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Row(
            children: List.generate(_moods.length, (i) {
              final sel = _selected == i;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: sel
                        ? kGreen.withValues(alpha: 0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: sel ? kGreen : Colors.transparent,
                        width: 1),
                  ),
                  child: Text(_moods[i],
                      style: TextStyle(
                          fontSize: sel ? 22 : 20)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// QUICK ACCESS
// ─────────────────────────────────────────────────────────
class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  static const _items = [
    _QAItem(
        icon: Icons.music_note_rounded,
        label: 'Sleep Sounds',
        sub: '12 tracks',
        color: Color(0xFF3A6B8A)),
    _QAItem(
        icon: Icons.auto_stories_rounded,
        label: 'Bedtime Stories',
        sub: '8 stories',
        color: Color(0xFF5A4A7A)),
    _QAItem(
        icon: Icons.self_improvement_rounded,
        label: 'Meditation',
        sub: '5 sessions',
        color: Color(0xFF3A6B5A)),
    _QAItem(
        icon: Icons.do_not_disturb_on_rounded,
        label: 'Digital Detox',
        sub: 'Active now',
        color: Color(0xFF7A3A3A),
        activeAccent: Color(0xFFE57373)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('QUICK ACCESS',
            style: TextStyle(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (_, i) => _QACard(item: _items[i]),
        ),
      ],
    );
  }
}

class _QAItem {
  final IconData icon;
  final String label, sub;
  final Color color;
  final Color? activeAccent;
  const _QAItem(
      {required this.icon,
      required this.label,
      required this.sub,
      required this.color,
      this.activeAccent});
}

class _QACard extends StatelessWidget {
  final _QAItem item;
  const _QACard({required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon,
                color: item.activeAccent ??
                    item.color.withBlue(
                        ((item.color.b * 255.0).round() + 80)
                            .clamp(0, 255)
                            .toInt()),
                size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(item.sub,
                    style: TextStyle(
                        color: item.activeAccent ?? kMuted,
                        fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SLEEP TREND
// ─────────────────────────────────────────────────────────
class _SleepTrendSection extends StatelessWidget {
  const _SleepTrendSection();

  // Hours of sleep per day (Mon–Sun)
  static const _data = [5.5, 6.0, 4.5, 5.0, 6.5, 7.5, 8.5];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SLEEP TREND',
            style: TextStyle(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last 7 Days',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Avg ',
                            style: TextStyle(
                                color: kMuted, fontSize: 12)),
                        TextSpan(
                            text: '7.2 hrs',
                            style: TextStyle(
                                color: kGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: _BarChart(data: _data, days: _days),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> days;
  const _BarChart({required this.data, required this.days});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(data.length, (i) {
        final frac    = data[i] / maxVal;
        final isLast  = i == data.length - 1;   // Sunday highlight
        final isSat   = i == data.length - 2;
        final barColor = (isLast || isSat) ? kGold : kGreenLt;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600 + i * 60),
                  curve: Curves.easeOutCubic,
                  width: 22,
                  height: 80 * frac,
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: isLast ? 1.0 : 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(days[i],
                style: TextStyle(
                    color: isLast ? Colors.white : kMuted,
                    fontSize: 12,
                    fontWeight: isLast
                        ? FontWeight.w600
                        : FontWeight.w400)),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selected;
  final ValueChanged<int> onTap;
  const _BottomNav(
      {required this.items,
      required this.selected,
      required this.onTap});

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
        children: List.generate(items.length, (i) {
          final sel = selected == i;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel
                    ? kGreen.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].icon,
                      color: sel ? kGreenLt : kMuted,
                      size: 22),
                  const SizedBox(height: 3),
                  Text(items[i].label,
                      style: TextStyle(
                          color: sel ? kGreenLt : kMuted,
                          fontSize: 9,
                          fontWeight: sel
                              ? FontWeight.w600
                              : FontWeight.w400,
                          letterSpacing: 0.5)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
