import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SleepAnalyzerScreen extends StatelessWidget {
  const SleepAnalyzerScreen({super.key});

  static const Color bgColor = Color(0xFF08111E);
  static const Color cardColor = Color(0xFF121D2D);

  static const Color primaryBlue = Color(0xFF6DA8FF);
  static const Color primaryPurple = Color(0xFF8B7BFF);
  static const Color accentMint = Color(0xFF7EE6C4);
  static const Color accentGold = Color(0xFFFFD27A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Sleep Analyzer",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.nightlight_round,
                      color: accentGold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// HERO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF243B55),
                      Color(0xFF141E30),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircularPercentIndicator(
                          radius: 55,
                          lineWidth: 10,
                          animation: true,
                          animationDuration: 1500,
                          percent: 0.84,
                          circularStrokeCap:
                              CircularStrokeCap.round,
                          backgroundColor:
                              Colors.white12,
                          progressColor:
                              accentGold,
                          center: const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                "84",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Score",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Sleep Wellness",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                "Your sleep improved by 14% this week.",
                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Recovery: Excellent",
                                style: TextStyle(
                                  color:
                                      accentMint,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(.06),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [

                          Icon(
                            Icons.auto_awesome,
                            color: accentGold,
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              "Tonight is ideal for deep recovery sleep. Try sleeping before 11 PM.",
                              style: TextStyle(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _sectionTitle("Sleep Trend"),

              const SizedBox(height: 15),

              Container(
                height: 320,
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: LineChart(
                  LineChartData(
                    minY: 5,
                    maxY: 9,

                    borderData: FlBorderData(show: false),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white10,
                          strokeWidth: 1,
                        );
                      },
                    ),

                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 14,
                        getTooltipItems: (spots) {
                          const days = [
                            "Sunday",
                            "Monday",
                            "Tuesday",
                            "Wednesday",
                            "Thursday",
                            "Friday",
                            "Saturday",
                          ];

                          return spots.map((spot) {
                            return LineTooltipItem(
                              "${days[spot.x.toInt()]}\n${spot.y.toStringAsFixed(1)} hrs",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),

                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              "S",
                              "M",
                              "T",
                              "W",
                              "T",
                              "F",
                              "S",
                            ];

                            if (value.toInt() < 0 || value.toInt() >= days.length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 5.8),
                          FlSpot(1, 6.9),
                          FlSpot(2, 6.3),
                          FlSpot(3, 8.2),
                          FlSpot(4, 6.8),
                          FlSpot(5, 7.8),
                          FlSpot(6, 8.2),
                        ],
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD27A),
                            Color(0xFFFFB347),
                          ],
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: const Color(0xFFFFD27A),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFFFD27A).withOpacity(.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _sectionTitle("Monthly Sleep Quality"),

              const SizedBox(height: 15),

        Container(
  height: 250,
  padding: const EdgeInsets.all(20),
  decoration: _cardDecoration(),
  child: LineChart(
    LineChartData(
      minY: 60,
      maxY: 100,

      borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),

      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 14,
          getTooltipItems: (spots) {
            const weeks = [
              "Week 1",
              "Week 2",
              "Week 3",
              "Week 4",
            ];

            return spots.map((spot) {
              return LineTooltipItem(
                "${weeks[spot.x.toInt()]}\n${spot.y.toInt()}%",
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),

      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const weeks = [
                "W1",
                "W2",
                "W3",
                "W4",
              ];

              if (value.toInt() < 0 ||
                  value.toInt() >= weeks.length) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  weeks[value.toInt()],
                  style: const TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 72),
            FlSpot(1, 88),
            FlSpot(2, 76),
            FlSpot(3, 92),
          ],

          isCurved: true,
          barWidth: 4,
          isStrokeCapRound: true,

          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFD27A),
              Color(0xFFFFB347),
            ],
          ),

          dotData: FlDotData(
            show: true,
            getDotPainter:
                (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: const Color(0xFFFFD27A),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),

          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFD27A)
                    .withOpacity(.25),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
              const SizedBox(height: 30),

              _sectionTitle("Wellness Metrics"),

              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: const [

                  WellnessCard(
                    icon: Icons.favorite,
                    value: "92%",
                    label: "Recovery",
                    color: accentMint,
                  ),

                  WellnessCard(
                    icon: Icons.nightlight_round,
                    value: "1h 20m",
                    label: "Sleep Debt",
                    color: accentGold,
                  ),

                  WellnessCard(
                    icon: Icons.track_changes,
                    value: "85%",
                    label: "Consistency",
                    color: primaryBlue,
                  ),

                  WellnessCard(
                    icon: Icons.hotel,
                    value: "8h 34m",
                    label: "Best Sleep",
                    color: primaryPurple,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _sectionTitle("AI Sleep Coach"),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accentMint
                            .withOpacity(.15),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "GOOD",
                        style: TextStyle(
                          color: accentMint,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Strengths",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _coachItem(
                      "Consistent bedtime",
                      accentMint,
                    ),

                    _coachItem(
                      "Healthy recovery",
                      accentMint,
                    ),

                    _coachItem(
                      "Good sleep duration",
                      accentMint,
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Focus Areas",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _coachItem(
                      "Weekend oversleeping",
                      Colors.orange,
                    ),

                    _coachItem(
                      "Screen exposure before bed",
                      Colors.orange,
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(.05),
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),
                      child: const Text(
                        "Recommendation: Sleep before 11 PM and avoid screens for at least 30 minutes before bedtime.",
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _sectionTitle(
                "Natural Recommendations",
              ),

              const SizedBox(height: 15),

              const RecommendationCard(
                icon: Icons.local_cafe,
                title: "Chamomile Tea",
                subtitle:
                    "Promotes relaxation before bedtime.",
              ),

              const SizedBox(height: 15),

              const RecommendationCard(
                icon: Icons.self_improvement,
                title: "Breathing Exercise",
                subtitle:
                    "5 minutes of mindful breathing.",
              ),

              const SizedBox(height: 15),

              const RecommendationCard(
                icon: Icons.mobile_off,
                title: "Digital Detox",
                subtitle:
                    "Avoid screens 30 minutes before sleep.",
              ),
                            const SizedBox(height: 30),

              _sectionTitle("Recent Sleep Scores"),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    _scoreTile(
                      "Monday",
                      "87",
                      "Excellent",
                    ),

                    const Divider(
                      color: Colors.white12,
                    ),

                    _scoreTile(
                      "Tuesday",
                      "82",
                      "Good",
                    ),

                    const Divider(
                      color: Colors.white12,
                    ),

                    _scoreTile(
                      "Wednesday",
                      "78",
                      "Average",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _sectionTitle("Sleep Report"),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: _cardDecoration(),
                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: accentGold,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Generate Wellness Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              accentGold,
                          foregroundColor:
                              Colors.black,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Generate PDF Report",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _coachItem(
    String text,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _scoreTile(
    String day,
    String score,
    String status,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            day,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        Text(
          score,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          status,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  static BarChartGroupData _bar(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 24,
          borderRadius:
              BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              primaryPurple,
              accentGold,
            ],
          ),
        ),
      ],
    );
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: Colors.white10,
      ),
    );
  }
}

class WellnessCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const WellnessCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SleepAnalyzerScreen.cardColor,
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(height: 15),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const RecommendationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SleepAnalyzerScreen.cardColor,
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color:
                  SleepAnalyzerScreen.accentGold,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}