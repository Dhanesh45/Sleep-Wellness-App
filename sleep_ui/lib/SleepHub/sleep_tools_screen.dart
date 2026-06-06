import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_theme.dart';
import 'shared_widgets.dart';

class SleepToolsScreen extends StatefulWidget {
  const SleepToolsScreen({super.key});

  @override
  State<SleepToolsScreen> createState() => _SleepToolsScreenState();
}

class _SleepToolsScreenState extends State<SleepToolsScreen> {
  int _cycleTab = 0; // 0: Wake Up At, 1: Go to Sleep Now
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 0);

  // 90-minute cycle options for "Wake Up At 6:00 AM"
  List<Map<String, dynamic>> get _cycleOptions {
    final wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    return [
      {
        'cycles': 6,
        'label': 'Optimal',
        'minutes': wakeMinutes - (6 * 90 + 14),
        'color': AppColors.accentGreen,
      },
      {
        'cycles': 5,
        'label': '5 Cycles',
        'minutes': wakeMinutes - (5 * 90 + 14),
        'color': AppColors.textSecondary,
      },
      {
        'cycles': 4,
        'label': '4 Cycles',
        'minutes': wakeMinutes - (4 * 90 + 14),
        'color': AppColors.textSecondary,
      },
      {
        'cycles': 3,
        'label': '3 Cycles, Low',
        'minutes': wakeMinutes - (3 * 90 + 14),
        'color': AppColors.accentRed,
      },
    ];
  }

  String _minutesToTimeStr(int minutes) {
    final normalized = ((minutes % 1440) + 1440) % 1440;
    final h = normalized ~/ 60;
    final m = normalized % 60;
    final period = h >= 12 ? 'PM' : 'AM';
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pickWakeTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentOrange,
            onSurface: AppColors.textPrimary,
          ),
          dialogBackgroundColor: AppColors.bgCard,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _wakeTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep Tools',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Text(
              'Plan, optimize, and improve',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        actions: [
          const Icon(
            Icons.nightlight_round,
            color: AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.build_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildTonightGoal()),
          SliverToBoxAdapter(child: _buildCycleCalculator()),
          SliverToBoxAdapter(child: _buildGoalProgress()),
          SliverToBoxAdapter(child: _buildDebtTracker()),
          SliverToBoxAdapter(child: _buildAiPredictor()),
          SliverToBoxAdapter(child: _buildRecoveryPlanner()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildQuoteCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildTonightGoal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgCard, AppColors.accentOrange.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "TONIGHT'S GOAL",
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.accentOrange,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Sleep Duration: 8h',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _goalTimeBox(
                    Icons.nightlight_round,
                    'Bedtime',
                    '10:15 PM',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _goalTimeBox(
                    Icons.wb_sunny_rounded,
                    'Wake Time',
                    '6:15 AM',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalTimeBox(IconData icon, String label, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCardMid,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCycleCalculator() {
    final wakeFormatted =
        '${_wakeTime.hourOfPeriod.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')} ${_wakeTime.period == DayPeriod.am ? 'AM' : 'PM'}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cycle Calculator',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            // Tab bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCardMid,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _cycleTabBtn(0, 'Wake Up At'),
                  _cycleTabBtn(1, 'Go to Sleep Now'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'When do you want to wake up?',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickWakeTime,
              child: Text(
                wakeFormatted,
                style: const TextStyle(
                  color: AppColors.accentOrange,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Suggested bedtimes for optimal cycles:',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(_cycleOptions.length, (i) {
                final opt = _cycleOptions[i];
                return _cycleOptionCard(
                  _minutesToTimeStr(opt['minutes'] as int),
                  '${opt['cycles']} Cycles',
                  opt['label'] as String,
                  opt['color'] as Color,
                  i == 0,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cycleTabBtn(int idx, String label) {
    final selected = _cycleTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _cycleTab = idx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // FIX: Ensure margin is explicitly defined and positive
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            // Ensure color is never null
            color: selected ? AppColors.accentOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.black : AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cycleOptionCard(
    String time,
    String cycles,
    String label,
    Color labelColor,
    bool optimal,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: optimal
            ? AppColors.accentOrange.withOpacity(0.1)
            : AppColors.bgCardMid,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: optimal
              ? AppColors.accentOrange.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              color: optimal ? AppColors.accentOrange : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flag_rounded,
                  color: AppColors.accentOrange,
                  size: 18,
                ),
                const Spacer(),
                const Text(
                  '78%',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Sleep 8 Hours Daily',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GradientProgressBar(progress: 0.78),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _goalStat(
                    Icons.local_fire_department_rounded,
                    AppColors.accentOrange,
                    '8 Days',
                    'Streak',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _goalStat(
                    Icons.calendar_month_rounded,
                    AppColors.accentBlue,
                    '23/30',
                    'Month',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalStat(IconData icon, Color color, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCardMid,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(icon, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildDebtTracker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sleep Debt Tracker',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Weekly accumulation',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Healthy',
                    style: TextStyle(
                      color: AppColors.accentGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _debtStat('Recommended', '8h'),
                _debtStat('Average', '6h 40m'),
                _debtStat('Debt', '1h 20m', valueColor: AppColors.accentOrange),
              ],
            ),
            const SizedBox(height: 14),
            // Gradient debt slider
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accentGreen,
                        AppColors.accentOrange,
                        AppColors.accentRed,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(top: -4),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentOrange,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentOrange.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Optimal',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9),
                ),
                Text(
                  'Critical',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _debtStat(String label, String value, {Color? valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiPredictor() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '✨ AI PREDICTOR',
                    style: TextStyle(
                      color: AppColors.accentOrange,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Optimal Bedtime tonight',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '10:17 PM',
                  style: TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '92%',
                      style: TextStyle(
                        color: AppColors.accentGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Recovery Potential',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Expect 7h 58m sleep',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryPlanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.replay_rounded,
                        color: AppColors.accentGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Recovery Planner',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Status: Excellent',
                    style: TextStyle(
                      color: AppColors.accentGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _recoveryTip(Icons.alarm_rounded, 'Sleep 30m earlier'),
                  const SizedBox(height: 8),
                  _recoveryTip(
                    Icons.phone_android_rounded,
                    'Avoid screens 45m before',
                  ),
                  const SizedBox(height: 8),
                  _recoveryTip(Icons.trending_up_rounded, 'Maintain streak'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                const Text(
                  '92%',
                  style: TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Recovery',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recoveryTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 13),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      (Icons.add_circle_outline_rounded, 'Set Sleep Goal'),
      (Icons.notifications_rounded, 'Bedtime Reminder'),
      (Icons.calculate_rounded, 'Calculate Time'),
      (Icons.bar_chart_rounded, 'View Progress'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: actions
            .map(
              (a) => GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a.$1, color: AppColors.accentOrange, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          a.$2,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentPurple.withOpacity(0.15),
              AppColors.accentOrange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: const [
            Text(
              '"Consistency matters more than intensity. A steady sleep rhythm recalibrates your entire biological clock for peak daytime performance."',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '— SLEEP INSIGHTS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
