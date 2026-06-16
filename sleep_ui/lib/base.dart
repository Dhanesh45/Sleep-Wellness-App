import 'package:flutter/material.dart';

// Your teammate's screen imports
import 'package:sleep_ui/screens/splash_screen.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_login_screen.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_signup_screen.dart';
import 'package:sleep_ui/screens/login_screen.dart';
import 'package:sleep_ui/screens/signup_screen.dart';
import 'package:sleep_ui/screens/onboarding_screen.dart';
import 'package:sleep_ui/screens/home_screen.dart';
import 'package:sleep_ui/screens/digital_detox_screen.dart';
import 'package:sleep_ui/screens/sleep_calculator_screen.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/DeepSleepAudioPlayer.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/sanctuary_screen.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/voice_mode_screen.dart';
import 'package:sleep_ui/story/screens/stories_screen.dart';
import 'package:sleep_ui/story/screens/story_details_screen.dart';
import 'package:sleep_ui/story/models/story_template.dart';
import 'package:sleep_ui/screens/voice_lullaby_screen.dart';

// --- NEW BASE PAGE FOR TESTING SCREENS ---
class BaseNavigationPage extends StatelessWidget {
  const BaseNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Menu: Test Screens'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select a screen to view:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildNavButton(context, 'Splash Screen', SplashScreen()),
              _buildNavButton(context, 'Onboarding Screen', OnboardingScreen()),
              _buildNavButton(context, 'Restora Login', const RestoraLoginScreen()),
              _buildNavButton(context, 'Restora Signup', const RestoraSignUpScreen()),
              _buildNavButton(context, 'Login Screen (old)', LoginScreen()),
              _buildNavButton(context, 'Signup Screen (old)', SignUpScreen()),
              _buildNavButton(
                context,
                'Sanctuary Screen',
                const SanctuaryHomePage(),
              ),
              _buildNavButton(
                context,
                'SleepMate Voice',
                const VoiceModeScreen(),
              ),
              _buildNavButton(context, 'Home Screen', HomeScreen()),
              _buildNavButton(
                context,
                'Sleep Calculator',
                SleepCalculatorScreen(),
              ),
              _buildNavButton(context, 'Digital Detox', DigitalDetoxScreen()),
              _buildNavButton(
                context,
                'Deep Sleep Audio Player',
                DeepSleepAudioPlayer(),
              ),
              _buildNavButton(
                context,
                'Sleep Stories (Localized)',
                const StoriesScreen(),
              ),
              _buildNavButton(
                context,
                'Story Details (Dummy)',
                StoryDetailsScreen(
                  story: StoryTemplate(
                    storyid: 'dummy-id',
                    title: 'The Whispering Pines',
                    description: 'Drift into a world where the trees share ancient secrets and the wind carries the weight of a thousand peaceful dreams. This story follows a lone traveler finding their way home through the glow of bioluminescent flora and the soft hum of the earth.',
                    storyText: 'Dummy story text content that is quite long to test things.',
                    language: 'en',
                    thumbnailPath: 'assets/images/ravenstorytb.png',
                    createdat: DateTime.now(),
                  ),
                ),
              ),
              _buildNavButton(
                context,
                'Voice Lullaby (Upload)',
                const VoiceLullabyScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String buttonText,
    Widget targetScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          },
          child: Text(buttonText, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
