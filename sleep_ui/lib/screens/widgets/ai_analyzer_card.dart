class AIAnalyzerCard extends StatelessWidget {
  const AIAnalyzerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2434),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: const [

          Text(
            "🧠 AI Sleep Analyzer",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Text(
            "Overall Status: GOOD",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),

          SizedBox(height: 20),

          Text(
            "✓ Consistent Bedtime",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          Text(
            "✓ Healthy Recovery",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          Text(
            "⚠ Sleep Debt Detected",
            style: TextStyle(
              color: Colors.orange,
            ),
          ),

          SizedBox(height: 20),

          Text(
            "Recommendation",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Sleep before 11 PM and reduce screen exposure by 30 minutes.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}