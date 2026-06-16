class RecoveryCard extends StatelessWidget {
  const RecoveryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2434),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: const [

          Text(
            "Recovery Analysis",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),

          SizedBox(height: 20),

          ScoreInfo(
            title: "Physical",
            value: "89%",
          ),

          SizedBox(height: 15),

          ScoreInfo(
            title: "Mental",
            value: "94%",
          ),

          SizedBox(height: 15),

          ScoreInfo(
            title: "Recovery",
            value: "92%",
          ),
        ],
      ),
    );
  }
}