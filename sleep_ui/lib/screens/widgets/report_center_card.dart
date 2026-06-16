class ReportCenterCard extends StatelessWidget {
  const ReportCenterCard({super.key});

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
            "Sleep Reports",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {

              // generate pdf

            },
            child: const Text(
              "Generate Weekly Report",
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Generate Monthly Report",
            ),
          ),
        ],
      ),
    );
  }
}