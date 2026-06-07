import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/sanctuary_screen.dart';

// Restora auth design tokens (from mockup)
const restoraBg = Color(0xFF0C0F14);
const restoraCard = Color(0xFF141820);
const restoraInput = Color(0xFF1A1F28);
const restoraBorder = Color(0xFF2A3140);
const restoraOrange = Color(0xFFE8A849);
const restoraOrangeDark = Color(0xFFB87A2A);
const restoraMuted = Color(0xFF8B95A5);
const restoraTabSelected = Color(0xFF2A2218);

void navigateToSanctuary(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const SanctuaryHomePage()),
    (_) => false,
  );
}

void showRestoraMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: restoraCard,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

InputDecoration restoraFieldDecoration({
  required String label,
  required IconData icon,
  String? hint,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
    hintStyle: GoogleFonts.inter(color: restoraMuted.withValues(alpha: 0.6), fontSize: 14),
    prefixIcon: Icon(icon, color: restoraMuted, size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: restoraInput,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: restoraBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: restoraOrange, width: 1.2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  );
}

class RestoraMoonLogo extends StatelessWidget {
  const RestoraMoonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: restoraCard,
        border: Border.all(color: restoraBorder),
        boxShadow: [
          BoxShadow(
            color: restoraOrange.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.nightlight_round,
        color: restoraOrange,
        size: 34,
      ),
    );
  }
}

class RestoraPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const RestoraPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: restoraOrange,
          disabledBackgroundColor: restoraOrange.withValues(alpha: 0.4),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RestoraGoogleButton extends StatelessWidget {
  final VoidCallback? onTap;

  const RestoraGoogleButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: restoraInput,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: restoraBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'G',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestoraOrDivider extends StatelessWidget {
  final String label;

  const RestoraOrDivider({super.key, this.label = 'or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: restoraBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: restoraBorder)),
      ],
    );
  }
}
