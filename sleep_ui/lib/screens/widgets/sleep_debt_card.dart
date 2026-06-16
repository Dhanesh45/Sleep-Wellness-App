class SleepDebtCard extends StatelessWidget {
  const SleepDebtCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2434),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [

          const Text(
            "Sleep Debt",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(
            value: .85,
            backgroundColor:
                Colors.grey.shade800,
            color: const Color(0xFFFFB63F),
          ),

          const SizedBox(height: 15),

          const Text(
            "Missing 4.3h this week",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}