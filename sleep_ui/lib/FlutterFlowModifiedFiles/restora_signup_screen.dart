import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_auth_shared.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_login_screen.dart';
import 'package:sleep_ui/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestoraSignUpScreen extends StatefulWidget {
  const RestoraSignUpScreen({super.key});

  @override
  State<RestoraSignUpScreen> createState() => _RestoraSignUpScreenState();
}

class _RestoraSignUpScreenState extends State<RestoraSignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _agreed = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (!_agreed) {
      showRestoraMessage(context, 'Please agree to the Terms of Service.');
      return;
    }
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showRestoraMessage(context, 'Please fill in all fields.');
      return;
    }
    if (password.length < 6) {
      showRestoraMessage(context, 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _loading = true);
    try {
      await SupabaseService.instance.signUp(
        email: email,
        password: password,
        fullName: name,
      );
      if (!mounted) return;

      if (SupabaseService.instance.currentUser != null) {
        navigateToSanctuary(context);
      } else {
        showRestoraMessage(
          context,
          'Check your email to confirm your account, then sign in.',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RestoraLoginScreen()),
        );
      }
    } on AuthException catch (e) {
      showRestoraMessage(context, e.message);
    } on Exception catch (e) {
      final message = e.toString();
      if (message.contains('SocketException') ||
          message.contains('Failed host lookup')) {
        showRestoraMessage(
          context,
          'Cannot reach Supabase. Check phone internet/DNS and verify '
          'SUPABASE_URL in .env has no trailing = character.',
        );
      } else {
        showRestoraMessage(context, 'Sign up failed: $message');
      }
    } catch (e) {
      showRestoraMessage(context, 'Sign up failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: restoraBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RestoraLoginScreen()),
                ),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: restoraInput,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: restoraBorder),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Create your\n',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'Restora',
                      style: GoogleFonts.inter(
                        color: restoraOrange,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Begin your journey to restful nights and mindful mornings.',
                style: GoogleFonts.inter(
                  color: restoraMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              _FieldLabel('Full Name'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: restoraFieldDecoration(
                  label: '',
                  icon: Icons.person_outline_rounded,
                  hint: 'How should we call you?',
                ),
              ),
              const SizedBox(height: 18),
              _FieldLabel('Email Address'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: restoraFieldDecoration(
                  label: '',
                  icon: Icons.mail_outline_rounded,
                  hint: 'your@email.com',
                ),
              ),
              const SizedBox(height: 18),
              _FieldLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: restoraFieldDecoration(
                  label: '',
                  icon: Icons.lock_outline_rounded,
                  hint: 'Create a secure password',
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: restoraMuted,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => setState(() => _agreed = !_agreed),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _agreed ? restoraOrange : Colors.transparent,
                        border: Border.all(
                          color: _agreed ? restoraOrange : restoraBorder,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _agreed
                          ? const Icon(Icons.check_rounded,
                              color: Colors.black, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: restoraMuted,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.inter(
                                color: restoraOrange,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.inter(
                                color: restoraOrange,
                                decoration: TextDecoration.underline,
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
              RestoraPrimaryButton(
                label: _loading ? 'Creating account...' : 'Create Account',
                onPressed: _loading ? null : _handleSignUp,
              ),
              const SizedBox(height: 24),
              const RestoraOrDivider(label: 'or join with'),
              const SizedBox(height: 20),
              RestoraGoogleButton(
                onTap: () => showRestoraMessage(
                  context,
                  'Google sign-in coming soon.',
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(color: restoraMuted, fontSize: 14),
                    children: [
                      const TextSpan(text: 'Already have a sanctuary? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestoraLoginScreen(),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              color: restoraOrange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: restoraCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: restoraBorder,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined,
                        color: restoraOrange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy First Architecture',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your sleep data is encrypted and processed securely via Supabase.',
                            style: GoogleFonts.inter(
                              color: restoraMuted,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
    );
  }
}
