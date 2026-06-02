import 'package:flutter/material.dart';
import 'package:sleep_ui/screens/signup_screen.dart';

// ─────────────────────────────────────────────────────────
// SHARED DESIGN TOKENS
// ─────────────────────────────────────────────────────────
const kBg           = Color(0xFF111827);
const kBgCard       = Color(0xFF1C2433);
const kBgInput      = Color(0xFF1E2A38);
const kGold         = Color(0xFFD4A017);
const kGoldLight    = Color(0xFFF5C842);
const kGreen        = Color(0xFF4A7C6A);
const kGreenLight   = Color(0xFF5E9E89);
const kTextPrimary  = Colors.white;
const kTextMuted    = Color(0xFF8A95A3);
const kBorder       = Color(0xFF2A3444);

InputDecoration serenovaInput(String label, IconData icon,
    {Widget? suffix}) {
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
// APP ENTRY
// ─────────────────────────────────────────────────────────
void main() => runApp(const SerenovaApp());

class SerenovaApp extends StatelessWidget {
  const SerenovaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl    = TextEditingController(text: 'hello@example.com');
  final _passwordCtrl = TextEditingController(text: '••••••••••');
  bool _obscure       = true;

  late AnimationController _fade;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fadeAnim =
        CurvedAnimation(parent: _fade, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fade.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    Widget body = FadeTransition(
      opacity: _fadeAnim,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40 : 28, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            const Text(
              'Welcome back',
              style: TextStyle(
                color: kTextPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to continue your sleep journey',
              style: TextStyle(
                color: kTextMuted,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 36),

            // ── Email ────────────────────────────────────
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration:
                  serenovaInput('Email', Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 14),

            // ── Password ─────────────────────────────────
            TextField(
              controller: _passwordCtrl,
              obscureText: _obscure,
              style: const TextStyle(color: kTextPrimary, fontSize: 15),
              decoration: serenovaInput(
                'Password',
                Icons.lock_outline_rounded,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kTextMuted,
                    size: 20,
                  ),
                ),
              ),
            ),

            // ── Forgot password ──────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 6),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kGold,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Sign In button ───────────────────────────
            _PillButton(
              label: 'Sign In',
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // ── Divider ──────────────────────────────────
            _OrDivider(),
            const SizedBox(height: 20),

            // ── Google ────────────────────────────────────
            _SocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'Continue with Google',
              onTap: () {},
            ),
            const SizedBox(height: 28),

            // ── Create account ────────────────────────────
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: kTextMuted, fontSize: 14),
                  children: [
                    const TextSpan(text: 'New here? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        ),
                        child: const Text(
                          'Create account',
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
      body: SafeArea(child: SingleChildScrollView(child: body)),
    );
  }
}

// ─────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS (used by both screens via import)
// ─────────────────────────────────────────────────────────
class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: kBorder, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('or',
              style: TextStyle(color: kTextMuted, fontSize: 12)),
        ),
        Expanded(child: Divider(color: kBorder, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: kBgInput,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kTextPrimary, size: 24),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
