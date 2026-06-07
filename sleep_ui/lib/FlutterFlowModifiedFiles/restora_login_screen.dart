import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_auth_shared.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_signup_screen.dart';
import 'package:sleep_ui/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestoraLoginScreen extends StatefulWidget {
  const RestoraLoginScreen({super.key});

  @override
  State<RestoraLoginScreen> createState() => _RestoraLoginScreenState();
}

class _RestoraLoginScreenState extends State<RestoraLoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  int _selectedTab = 0;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      showRestoraMessage(context, 'Please enter your email and password.');
      return;
    }

    setState(() => _loading = true);
    try {
      await SupabaseService.instance.signIn(email: email, password: password);
      if (!mounted) return;
      navigateToSanctuary(context);
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
        showRestoraMessage(context, 'Sign in failed: $message');
      }
    } catch (e) {
      showRestoraMessage(context, 'Sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onTabSelected(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RestoraSignUpScreen()),
      );
      return;
    }
    if (index == 2) {
      showRestoraMessage(context, 'Reports coming soon.');
      return;
    }
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: restoraBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            children: [
              const RestoraMoonLogo(),
              const SizedBox(height: 24),
              Text(
                'Welcome to Restora',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your journey to restful sleep begins here',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: restoraMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),
              _AuthTabBar(
                selected: _selectedTab,
                onSelected: _onTabSelected,
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: restoraFieldDecoration(
                  label: '',
                  icon: Icons.mail_outline_rounded,
                  hint: 'name@example.com',
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: restoraFieldDecoration(
                  label: '',
                  icon: Icons.lock_outline_rounded,
                  hint: 'Enter your password',
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showRestoraMessage(
                      context,
                      'Password reset will be available soon.',
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      color: restoraOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              RestoraPrimaryButton(
                label: _loading ? 'Signing in...' : 'Continue to Sanctuary',
                onPressed: _loading ? null : _handleSignIn,
              ),
              const SizedBox(height: 24),
              const RestoraOrDivider(),
              const SizedBox(height: 20),
              RestoraGoogleButton(
                onTap: () => showRestoraMessage(
                  context,
                  'Google sign-in coming soon.',
                ),
              ),
              const SizedBox(height: 12),
              RestoraGoogleButton(
                onTap: () => showRestoraMessage(
                  context,
                  'Google sign-in coming soon.',
                ),
              ),
              const SizedBox(height: 28),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(color: restoraMuted, fontSize: 12),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.inter(
                        color: restoraOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, color: restoraMuted, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Supabase Secured & Encrypted',
                    style: GoogleFonts.inter(color: restoraMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthTabBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;

  const _AuthTabBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const tabs = ['Sign In', 'Create Account', 'Reports'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: restoraCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: restoraBorder),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? restoraTabSelected : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? Border.all(color: restoraOrange.withValues(alpha: 0.3))
                      : null,
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: isSelected ? restoraOrange : restoraMuted,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
