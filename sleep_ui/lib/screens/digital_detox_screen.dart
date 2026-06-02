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
      title: 'Serenova – Digital Detox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
      ),
      home: const DigitalDetoxScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// TOKENS
// ─────────────────────────────────────────────────────────
const kBg      = Color(0xFF111827);
const kCard    = Color(0xFF1C2433);
const kGreen   = Color(0xFF4A7C6A);
const kGreenLt = Color(0xFF5E9E89);
const kGold    = Color(0xFFD4A017);
const kMuted   = Color(0xFF8A95A3);
const kBorder  = Color(0xFF2A3444);
const kNavBg   = Color(0xFF161F2E);
const kWhite   = Colors.white;

// ─────────────────────────────────────────────────────────
// APP MODEL
// ─────────────────────────────────────────────────────────
class _AppEntry {
  final String   name;
  final IconData icon;
  final Color    iconBg;
  final Color    iconColor;
  bool restricted;

  _AppEntry({
    required this.name,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.restricted,
  });
}

// ─────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────
class DigitalDetoxScreen extends StatefulWidget {
  const DigitalDetoxScreen({super.key});
  @override
  State<DigitalDetoxScreen> createState() => _DigitalDetoxScreenState();
}

class _DigitalDetoxScreenState extends State<DigitalDetoxScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double>   _fade;

  final List<_AppEntry> _apps = [
    _AppEntry(
      name: 'Instagram',
      icon: Icons.star_outline_rounded,
      iconBg: const Color(0xFFD4522A),
      iconColor: kWhite,
      restricted: true,
    ),
    _AppEntry(
      name: 'YouTube',
      icon: Icons.play_circle_outline_rounded,
      iconBg: const Color(0xFFCC2222),
      iconColor: kWhite,
      restricted: true,
    ),
    _AppEntry(
      name: 'Twitter / X',
      icon: Icons.alternate_email_rounded,
      iconBg: const Color(0xFF1E3A5F),
      iconColor: const Color(0xFF5A9FD4),
      restricted: false,
    ),
  ];

  bool get _detoxActive => _apps.any((a) => a.restricted);

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

  void _addApp() {
    // Demo: toggle a new placeholder entry
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddAppSheet(
        onAdd: (name) {
          setState(() {
            _apps.add(_AppEntry(
              name: name,
              icon: Icons.apps_rounded,
              iconBg: const Color(0xFF2A3A4A),
              iconColor: kMuted,
              restricted: false,
            ));
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget body = FadeTransition(
      opacity: _fade,
      child: Column(
        children: [
          // ── App bar ──────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _IconBtn(
                    icon: Icons.arrow_back_ios_new_rounded, onTap: () {}),
                const Expanded(
                  child: Center(
                    child: Text('Digital Detox',
                        style: TextStyle(
                            color: kWhite,
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 16, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status banner ─────────────────────────────
                  _StatusBanner(active: _detoxActive),
                  const SizedBox(height: 24),

                  // ── Section label ─────────────────────────────
                  const Text('RESTRICTED APPS',
                      style: TextStyle(
                          color: kMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  // ── App list ──────────────────────────────────
                  ...List.generate(_apps.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AppRow(
                        entry: _apps[i],
                        onChanged: (v) =>
                            setState(() => _apps[i].restricted = v),
                      ),
                    );
                  }),
                  const SizedBox(height: 6),

                  // ── Add app button ────────────────────────────
                  GestureDetector(
                    onTap: _addApp,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: kGreen, width: 1.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              color: kGreenLt, size: 20),
                          SizedBox(width: 8),
                          Text('Add App to Restrict',
                              style: TextStyle(
                                  color: kGreenLt,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Footer quote ──────────────────────────────
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "You're doing great. Reducing screen time before sleep\nis one of the best gifts you can give yourself.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kMuted,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            height: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Bottom nav ───────────────────────────────────────
          const _BottomNav(selected: 1),
        ],
      ),
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
// STATUS BANNER
// ─────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final bool active;
  const _StatusBanner({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: active
            ? kGreen.withValues(alpha: 0.18)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: active ? kGreen : kBorder, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: active
                  ? kGreen.withValues(alpha: 0.25)
                  : kBorder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              active
                  ? Icons.shield_rounded
                  : Icons.shield_outlined,
              color: active ? kGreenLt : kMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  active
                      ? 'Bedtime Detox is Active'
                      : 'Bedtime Detox is Inactive',
                  style: TextStyle(
                    color: active ? kGreenLt : kMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  active
                      ? "You're protecting your sleep from 10:30 PM"
                      : 'Enable restrictions to protect your sleep.',
                  style: TextStyle(
                    color: active
                        ? kGreenLt.withValues(alpha: 0.7)
                        : kMuted,
                    fontSize: 12,
                    height: 1.5,
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

// ─────────────────────────────────────────────────────────
// APP ROW
// ─────────────────────────────────────────────────────────
class _AppRow extends StatelessWidget {
  final _AppEntry entry;
  final ValueChanged<bool> onChanged;
  const _AppRow({required this.entry, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(entry.icon, color: entry.iconColor, size: 22),
          ),
          const SizedBox(width: 14),

          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name,
                    style: const TextStyle(
                        color: kWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(
                  entry.restricted
                      ? 'Restricted after 10:30 PM'
                      : 'Not restricted',
                  style: TextStyle(
                    color: entry.restricted
                        ? const Color(0xFFE07050)
                        : kMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Switch(
            value: entry.restricted,
            onChanged: onChanged,
            activeThumbColor: kWhite,
            activeTrackColor: kGreenLt,
            inactiveThumbColor: kMuted,
            inactiveTrackColor: kBorder,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ADD APP BOTTOM SHEET
// ─────────────────────────────────────────────────────────
class _AddAppSheet extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const _AddAppSheet({required this.onAdd});
  @override
  State<_AddAppSheet> createState() => _AddAppSheetState();
}

class _AddAppSheetState extends State<_AddAppSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add App to Restrict',
              style: TextStyle(
                  color: kWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            style: const TextStyle(color: kWhite),
            decoration: InputDecoration(
              hintText: 'App name (e.g. TikTok)',
              hintStyle: const TextStyle(color: kMuted),
              filled: true,
              fillColor: const Color(0xFF1E2A38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: kGreen, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_ctrl.text.trim().isNotEmpty) {
                  widget.onAdd(_ctrl.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Add',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────
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
    (Icons.home_rounded,             'HOME'),
    (Icons.bedtime_rounded,          'SLEEP'),
    (Icons.self_improvement_rounded, 'CALM'),
    (Icons.auto_stories_rounded,     'STORIES'),
    (Icons.person_outline_rounded,   'PROFILE'),
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
              color: sel
                  ? kGreen.withValues(alpha: 0.18)
                  : Colors.transparent,
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
