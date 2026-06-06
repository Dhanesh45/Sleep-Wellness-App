import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'shared_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 0;
  int _selectedReportTab = 0;

  final List<String> _periods = ['Week', 'Month', 'Custom'];
  final List<String> _reportTabs = ['Weekly', 'Monthly', 'Custom'];

  // Weekly sleep data (hours)
  final List<double> _weeklyData = [6.5, 7.2, 6.8, 7.5, 8.0, 7.8, 7.7];
  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Monthly quality data (0–100)
  final List<double> _monthlyData = [72, 78, 68, 84];
  final List<String> _weeks = ['W1', 'W2', 'W3', 'W4'];

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
        title: const Text('Sleep Analytics'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: AppColors.accentOrange,
              size: 18,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildPeriodChips()),
          SliverToBoxAdapter(child: _buildScoreHeader()),
          SliverToBoxAdapter(child: _buildWeeklyChart()),
          SliverToBoxAdapter(child: _buildMonthlyChart()),
          SliverToBoxAdapter(child: _buildStatsGrid()),
          SliverToBoxAdapter(child: _buildInsightsSection()),
          SliverToBoxAdapter(child: _buildRecentScores()),
          SliverToBoxAdapter(child: _buildReportsSection()),
          SliverToBoxAdapter(child: _buildJourneyBanner()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildPeriodChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: List.generate(_periods.length, (i) {
          final selected = i == _selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accentOrange : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? AppColors.accentOrange
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  _periods[i],
                  style: TextStyle(
                    color: selected ? Colors.black : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const SleepScoreRing(
              score: 84,
              size: 84,
              showLabel: true,
              label: 'Score',
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sleep Quality: Good',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoRow(Icons.access_time_rounded, 'Avg. Duration: 7h 18m'),
                  const SizedBox(height: 6),
                  _infoRow(Icons.trending_up_rounded, 'Consistency: 85%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 13),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Sleep Duration',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: _LineChart(data: _weeklyData, labels: _weekDays),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Sleep Quality Trend',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: _BarChart(data: _monthlyData, labels: _weeks),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _miniStatCard(
                  Icons.bedtime_rounded,
                  AppColors.accentOrange,
                  '1h 20m',
                  'Below recommended',
                  '1h 20m',
                ),
                const SizedBox(height: 10),
                _miniStatCard(
                  Icons.local_fire_department_rounded,
                  AppColors.accentOrange,
                  '8 Days',
                  'Healthy consistency',
                  '8 Days',
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                _miniStatCard(
                  Icons.favorite_rounded,
                  AppColors.accentGreen,
                  '92%',
                  'Excellent recovery',
                  '92%',
                ),
                const SizedBox(height: 10),
                _miniStatCard(
                  Icons.star_rounded,
                  AppColors.accentOrange,
                  'Saturday',
                  '8h 34m sleep',
                  'Saturday',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatCard(
    IconData icon,
    Color color,
    String value,
    String subtitle,
    String tag,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                tag,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: AppColors.accentOrange, size: 16),
              SizedBox(width: 8),
              Text(
                'AI Sleep Insights',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _insightCard(
            Icons.lightbulb_rounded,
            AppColors.accentOrange,
            'Pattern Detected',
            'You consistently sleep better when you go to bed before 11 PM.',
          ),
          const SizedBox(height: 10),
          _insightCard(
            Icons.trending_up_rounded,
            AppColors.accentGreen,
            'Improvement',
            'Your sleep quality improved by 12% compared to last month.',
          ),
          const SizedBox(height: 10),
          _insightCard(
            Icons.warning_amber_rounded,
            AppColors.accentOrange,
            'Recommendation',
            'Your weekday sleep duration is 45 minutes lower than weekends.',
          ),
        ],
      ),
    );
  }

  Widget _insightCard(IconData icon, Color color, String title, String body) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScores() {
    final scores = [
      ('Monday', 87, 'Excellent'),
      ('Tuesday', 82, 'Good'),
      ('Wednesday', 78, 'Average'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Sleep Scores',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(scores.length, (i) {
                final s = scores[i];
                final color = s.$2 >= 85
                    ? AppColors.accentGreen
                    : s.$2 >= 75
                    ? AppColors.accentOrange
                    : AppColors.textSecondary;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: i < scores.length - 1
                        ? const Border(
                            bottom: BorderSide(
                              color: AppColors.cardBorder,
                              width: 0.5,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        s.$1,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        s.$2.toString(),
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(s.$3, style: TextStyle(color: color, fontSize: 12)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                        'Sleep Reports',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Generate professional reports with AI insights.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.description_rounded,
                  color: AppColors.accentOrange,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Report type tabs
            Row(
              children: List.generate(_reportTabs.length, (i) {
                final selected = i == _selectedReportTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedReportTab = i),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.bgCardLight
                            : AppColors.bgCardMid,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.accentOrange.withOpacity(0.5)
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            i == 0
                                ? Icons.calendar_view_week_rounded
                                : i == 1
                                ? Icons.calendar_month_rounded
                                : Icons.date_range_rounded,
                            color: selected
                                ? AppColors.accentOrange
                                : AppColors.textMuted,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _reportTabs[i],
                            style: TextStyle(
                              color: selected
                                  ? AppColors.accentOrange
                                  : AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Generate PDF Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Generated PDF card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bgCardMid,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.accentRed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly_Sleep_Summary.pdf',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Generated Oct 31 · 1.2 MB',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.share_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentOrange.withOpacity(0.2),
              AppColors.accentPurple.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentOrange.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Sleep Journey',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Small improvements in consistency can significantly improve recovery.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.4,
                    ),
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

// ─── Custom Line Chart ────────────────────────────────────────────────────────

class _LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const _LineChart({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(data: data, labels: labels),
      size: Size.infinite,
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;

  _LineChartPainter({required this.data, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    final minVal = data.reduce((a, b) => a < b ? a : b) - 0.5;
    final maxVal = data.reduce((a, b) => a > b ? a : b) + 0.5;
    final chartHeight = size.height - 24;
    final chartWidth = size.width;
    final xStep = chartWidth / (data.length - 1);

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y =
          chartHeight - ((data[i] - minVal) / (maxVal - minVal)) * chartHeight;
      points.add(Offset(x, y));
    }

    // Fill gradient
    final path = Path();
    path.moveTo(points.first.dx, chartHeight);
    for (final p in points) path.lineTo(p.dx, p.dy);
    path.lineTo(points.last.dx, chartHeight);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accentOrange.withOpacity(0.3),
            AppColors.accentOrange.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight)),
    );

    // Line
    final linePaint = Paint()
      ..color = AppColors.accentOrange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    for (final p in points) {
      canvas.drawCircle(
        p,
        4,
        Paint()
          ..color = AppColors.bgCard
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        p,
        3.5,
        Paint()
          ..color = AppColors.accentOrange
          ..style = PaintingStyle.fill,
      );
    }

    // Labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labels.length; i++) {
      tp.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
      );
      tp.layout();
      tp.paint(canvas, Offset(i * xStep - tp.width / 2, chartHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Custom Bar Chart ─────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;

  const _BarChart({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(data: data, labels: labels),
      size: Size.infinite,
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;

  _BarChartPainter({required this.data, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = 100.0;
    final chartHeight = size.height - 24;
    final barWidth = (size.width / data.length) * 0.5;
    final gap = size.width / data.length;

    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i] / maxVal) * chartHeight;
      final x = i * gap + (gap - barWidth) / 2;
      final y = chartHeight - barHeight;

      // Bar with gradient
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      canvas.drawRRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accentOrange,
              AppColors.accentOrange.withOpacity(
                0.7,
              ), // Changed to a valid color logic
            ],
          ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight)),
      );

      // Label
      final tp = TextPainter(textDirection: TextDirection.ltr);
      tp.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
      );
      tp.layout();
      tp.paint(canvas, Offset(i * gap + (gap - tp.width) / 2, chartHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
