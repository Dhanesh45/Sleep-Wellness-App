import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color accentColor = Color(0xFFF7A545);
const Color accentDark = Color(0xFFE38A24);

class SleepRemedyScreen extends StatelessWidget {
  const SleepRemedyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF050814),
              Color(0xFF09111F),
              Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Text(
                  "Sleep Remedy",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Natural remedies and breathing exercises\nfor a peaceful night's sleep.",
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                /// GUIDED BREATHING CARD

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A2142),
                        Color(0xFF111827),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [
        accentColor,
        accentDark,
      ],
    ),
  ),
                              child: const Text(
                                "Recommended",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              "Guided\nBreathing",
                              style:
                                  GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 30,
                                height: 1.1,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Slow your breathing,\nreduce stress and prepare your body for better sleep.",
                              style:
                                  GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/breathing',
                                  );
                                },
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor:
                                      Colors.white,
                                  elevation: 8,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(30),
                                  ),
                                ),
                                child: Text(
                                  "Begin Session",
                                  style:
                                      GoogleFonts.poppins(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 18),

                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
  colors: [
    accentColor,
    accentDark,
  ],
),
                          boxShadow: [
                            BoxShadow(
                             color: accentColor.withValues(alpha: .35),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.self_improvement,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// NATURAL REMEDIES

                Text(
                  "Natural Remedies",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
                                RemedyCard(
                  title: "Ashwagandha Root",
                  image:
                      "https://biozdrowy.pl/blog/wp-content/uploads/2024/07/Ashwagandha-czym-jest-i-jak-dziala-na-nasz-organizm-1024x538.jpg",
                  description:
                      "Ashwagandha is a powerful adaptogenic herb that helps reduce stress, promote relaxation, and improve overall sleep quality naturally.",
                ),

                const SizedBox(height: 20),

                RemedyCard(
                  title: "Turmeric Milk",
                  image:
                      "https://mypahadidukan.com/cdn/shop/articles/Turmeric_Milk_Benefits_1656eb68-5570-49f9-8caa-0f5d4e6b7f77.jpg?v=1772114235&width=1500",
                  description:
                      "A warm cup of turmeric milk before bedtime helps calm the body, supports recovery, and encourages a deeper night's sleep.",
                ),

                const SizedBox(height: 20),

                RemedyCard(
                  title: "Chamomile Tea",
                  image:
                      "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/chamomile-tea.jpg?w=1155&h=1528",
                  description:
                      "Chamomile tea has natural calming properties that relax the mind, reduce anxiety, and prepare your body for restful sleep.",
                ),

                const SizedBox(height: 30),

                Center(
                  child: Text(
                    "Sleep well • Wake refreshed 🌙",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
class RemedyCard extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const RemedyCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Image.network(
            image,
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [

                          Icon(
                            Icons.timer_outlined,
                            color: Colors.white70,
                            size: 17,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "10 mins",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: () {},

                      child: Row(
                        children: [
                          Text(
                            "View Remedy",
                            style: GoogleFonts.poppins(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 6),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}