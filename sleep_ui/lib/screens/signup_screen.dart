import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// Design tokens (duplicated so this file is self-contained)
// ─────────────────────────────────────────────────────────
const kBg          = Color(0xFF111827);
const kBgInput     = Color(0xFF1E2A38);
const kGold        = Color(0xFFD4A017);
const kGreen       = Color(0xFF4A7C6A);
const kGreenLight  = Color(0xFF5E9E89);
const kTextPrimary = Colors.white;
const kTextMuted   = Color(0xFF8A95A3);
const kBorder      = Color(0xFF2A3444);

InputDecoration _input(String label, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: kTextMuted, fontSize: 13),
    prefixIcon: Icon(icon, color: kTextMuted, size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: kBgInput,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: kGreen, width: 1.5),
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

// ─────────────────────────────────────────────────────────
// SIGN UP SCREEN
// ─────────────────────────────────────────────────────────
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool _agreed         = false;

  late AnimationController _fade;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _fade, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fade.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget body = FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40 : 28, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back button ──────────────────────────────
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kBgInput,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: kBorder),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: kTextPrimary, size: 16),
              ),
            ),
            const SizedBox(height: 28),

            // ── Mini wordmark ────────────────────────────
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.3),
                      radius: 0.75,
                      colors: [
                        Color(0xFFF5C842),
                        Color(0xFFD4A017),
                        Color(0xFF9A7010),
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kGold.withValues(alpha: 0.4),
                        blurRadius: 14,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Serenova',
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ── Headline ─────────────────────────────────
            const Text(
              'Create your\naccount',
              style: TextStyle(
                color: kTextPrimary,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Start your journey to better sleep tonight.',
              style: TextStyle(
                color: kTextMuted,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 32),

            // ── Full name ────────────────────────────────
            TextField(
              controller: _nameCtrl,
              style:
                  const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration: _input('Full name', Icons.person_outline_rounded),
            ),
            const SizedBox(height: 14),

            // ── Email ────────────────────────────────────
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style:
                  const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration:
                  _input('Email address', Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 14),

            // ── Password ─────────────────────────────────
            TextField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              style:
                  const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration: _input(
                'Password',
                Icons.lock_outline_rounded,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePass = !_obscurePass),
                  child: Icon(
                    _obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kTextMuted,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Confirm password ─────────────────────────
            TextField(
              controller: _confirmCtrl,
              obscureText: _obscureConfirm,
              style:
                  const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration: _input(
                'Confirm password',
                Icons.lock_outline_rounded,
                suffix: GestureDetector(
                  onTap: () => setState(
                      () => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kTextMuted,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Terms checkbox ───────────────────────────
            GestureDetector(
              onTap: () => setState(() => _agreed = !_agreed),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color:
                          _agreed ? kGreen : Colors.transparent,
                      border: Border.all(
                        color: _agreed ? kGreen : kBorder,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: _agreed
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            color: kTextMuted,
                            fontSize: 13,
                            height: 1.55),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: kGreenLight,
                              decoration: TextDecoration.underline,
                              decorationColor: kGreenLight,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: kGreenLight,
                              decoration: TextDecoration.underline,
                              decorationColor: kGreenLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Create account button ────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _agreed ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  disabledBackgroundColor: kGreen.withValues(alpha: 0.35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Divider ──────────────────────────────────
            Row(
              children: [
                Expanded(
                    child: Divider(color: kBorder, thickness: 1)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or',
                      style:
                          TextStyle(color: kTextMuted, fontSize: 12)),
                ),
                Expanded(
                    child: Divider(color: kBorder, thickness: 1)),
              ],
            ),
            const SizedBox(height: 16),

            // ── Google ────────────────────────────────────
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: kBgInput,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: kBorder),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata_rounded,
                        color: kTextPrimary, size: 24),
                    SizedBox(width: 10),
                    Text('Continue with Google',
                        style: TextStyle(
                            color: kTextPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Already have account ─────────────────────
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: kTextMuted, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: kGreenLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: kGreenLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (isWide) {
      return Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: body,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(child: body),
    );
  }
}
