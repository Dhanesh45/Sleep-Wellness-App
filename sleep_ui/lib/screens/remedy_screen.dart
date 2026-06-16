import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepRemedyScreen extends StatelessWidget {
  const SleepRemedyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
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
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Sleep Remedy",
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

              const SizedBox(height: 20),

              /// SCORE CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF11243C),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: 0.78,
                                strokeWidth: 8,
                                backgroundColor: Colors.white12,
                                color: Colors.lightBlueAccent,
                              ),
                              const Center(
                                child: Text(
                                  "78",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Good",
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Sleep Score",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Your sleep pattern can be improved with a few healthy habits and natural remedies.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ACTIONS
              Text(
                "Recommended Actions",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: .95,
                children: const [
                  ActionCard(
                    icon: Icons.mobile_off,
                    title: "Reduce Screens",
                    subtitle: "Avoid screens 1h before bed.",
                  ),
                  ActionCard(
                    icon: Icons.schedule,
                    title: "Consistency",
                    subtitle: "Sleep at consistent times.",
                  ),
                  ActionCard(
                    icon: Icons.coffee,
                    title: "Limit Caffeine",
                    subtitle: "No coffee after 4 PM.",
                  ),
                  ActionCard(
                    icon: Icons.bed,
                    title: "Sleep Earlier",
                    subtitle: "Aim for before 11 PM.",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// NATURAL REMEDIES
              Text(
                "Natural Remedies",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 15),

              RemedyCard(
                title: "Ashwagandha Root",
                image:
                    "https://biozdrowy.pl/blog/wp-content/uploads/2024/07/Ashwagandha-czym-jest-i-jak-dziala-na-nasz-organizm-1024x538.jpg",
                description:
                    "Traditionally used to support relaxation and stress management.",
              ),

              RemedyCard(
                title: "Turmeric Milk",
                image:
                    "https://mypahadidukan.com/cdn/shop/articles/Turmeric_Milk_Benefits_1656eb68-5570-49f9-8caa-0f5d4e6b7f77.jpg?v=1772114235&width=1500",
                description:
                    "A warm bedtime drink that promotes comfort and relaxation.",
              ),

              RemedyCard(
                title: "Chamomile Tea",
                image:
                    "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/chamomile-tea.jpg?w=1155&h=1528",
                description:
                    "A calming herbal tea often enjoyed before bedtime.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11243C),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 28),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF11243C),
        borderRadius: BorderRadius.circular(25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
            image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: const [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white54,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "10 min",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Read Recipe",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}