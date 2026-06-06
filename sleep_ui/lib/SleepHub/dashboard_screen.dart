import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'shared_widgets.dart';
import 'analytics_screen.dart';
import 'sleep_tools_screen.dart' hide AnalyticsScreen;
import 'sleepmate_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildScoreCard()),
            SliverToBoxAdapter(child: _buildLastNightCard()),
            SliverToBoxAdapter(child: _buildStatPills()),
            SliverToBoxAdapter(child: _buildToolsSection(context)),
            SliverToBoxAdapter(child: _buildRecommendationBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Good Evening ',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text('🌙', style: TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Welcome Back, User',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: AppCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const SleepScoreRing(score: 87, size: 88, strokeWidth: 8),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      'Excellent Sleep',
                      style: TextStyle(
                        color: AppColors.accentGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '7h 42m',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _scoreMetric('Quality', 'Good'),
                      const SizedBox(width: 20),
                      _scoreMetric('Consistency', '85%'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLastNightCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.bed_rounded, color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Night\'s Sleep',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '10:30 PM → 6:12 AM',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '7h 42m',
                  style: TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_rounded,
                      color: AppColors.accentOrange,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Good',
                      style: TextStyle(
                        color: AppColors.textMuted.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: const [
          StatPill(
            icon: Icons.bedtime_rounded,
            iconColor: AppColors.accentOrange,
            value: '1h 20m',
            label: 'Sleep Debt',
          ),
          SizedBox(width: 10),
          StatPill(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.accentOrange,
            value: '8 Days',
            label: 'Streak',
          ),
          SizedBox(width: 10),
          StatPill(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.accentGreen,
            value: '92%',
            label: 'Recovery',
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Sleep Tools & Insights',
            subtitle: 'Explore your sleep health in detail',
          ),
          const SizedBox(height: 14),
          ToolNavCard(
            icon: Icons.bar_chart_rounded,
            iconBg: AppColors.bgCardLight,
            title: 'Analytics & Reports',
            subtitle: 'View sleep trends, insights, and detailed statistics.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
            ),
          ),
          const SizedBox(height: 10),
          ToolNavCard(
            icon: Icons.architecture_rounded,
            iconBg: AppColors.bgCardLight,
            title: 'Sleep Tools',
            subtitle: 'Calculate ideal cycles and track recovery goals.',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SleepToolsScreen()),
            ),
          ),
          const SizedBox(height: 10),
          ToolNavCard(
            icon: Icons.smart_toy_rounded,
            iconBg: AppColors.bgCardLight,
            title: 'SleepMate AI',
            subtitle: 'Get personalized recommendations.',
            highlighted: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SleepMateScreen()),
            ),
            trailing: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          ToolNavCard(
            icon: Icons.lightbulb_rounded,
            iconBg: AppColors.bgCardLight,
            title: 'Daily Insight',
            subtitle: 'You sleep better when you go to bed before 11 PM.',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentOrange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [AppColors.accentOrange, AppColors.accentOrangeDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tonight's Recommendation",
                    style: TextStyle(
                      color: AppColors.accentOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Try sleeping 30 minutes earlier tonight to improve recovery.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
