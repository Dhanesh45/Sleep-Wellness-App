import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/gemini_client.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/sanctuary_theme.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/voice_state.dart';
import 'package:sleep_ui/config/gemini_config.dart';
import 'package:sleep_ui/services/supabase_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceModeScreen extends StatefulWidget {
  const VoiceModeScreen({super.key});

  @override
  State<VoiceModeScreen> createState() => _VoiceModeScreenState();
}

class _VoiceModeScreenState extends State<VoiceModeScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _inputCtrl = TextEditingController();

  GeminiClient? _gemini;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  VoiceState _state = VoiceState.idle;
  bool _speechReady = false;

  String _statusText = 'Tap to talk to SleepMate';
  String _lastUserText = '';
  String _lastBotText = '';

  @override
  void initState() {
    super.initState();

    if (GeminiConfig.isConfigured) {
      _gemini = GeminiClient(GeminiConfig.apiKey);
    }

    _setupTts();
    _initSpeech();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.9);

    _tts.setStartHandler(() {
      if (!mounted) return;
      setState(() {
        _state = VoiceState.speaking;
        _statusText = 'SleepMate is speaking...';
      });
      _syncOrbAnimation();
    });

    _tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() {
        _state = VoiceState.idle;
        _statusText = 'Tap to talk to SleepMate';
      });
      _syncOrbAnimation();
    });

    _tts.setErrorHandler((message) {
      if (!mounted) return;
      setState(() {
        _state = VoiceState.idle;
        _statusText = 'TTS error: $message';
      });
      _syncOrbAnimation();
    });
  }

  Future<void> _initSpeech() async {
    _speechReady = await _speech.initialize(
      onError: (_) {
        if (mounted) setState(() => _speechReady = false);
      },
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          if (_state == VoiceState.listening) {
            setState(() => _state = VoiceState.idle);
            _syncOrbAnimation();
          }
        }
      },
    );
  }

  void _syncOrbAnimation() {
    if (!mounted) return;
    switch (_state) {
      case VoiceState.idle:
        _animationController.duration = const Duration(milliseconds: 2000);
        break;
      case VoiceState.listening:
        _animationController.duration = const Duration(milliseconds: 800);
        break;
      case VoiceState.thinking:
        _animationController.duration = const Duration(milliseconds: 600);
        break;
      case VoiceState.speaking:
        _animationController.duration = const Duration(milliseconds: 1200);
        break;
    }
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _inputCtrl.dispose();
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final busy = _state == VoiceState.thinking || _state == VoiceState.speaking;

    return Scaffold(
      backgroundColor: SanctuaryTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _statusText,
                  key: ValueKey<String>(_statusText),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: _statusText.contains('error') || _statusText.contains('failed')
                        ? SanctuaryTheme.accentPink
                        : SanctuaryTheme.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isKeyboardOpen) ...[
                      const SizedBox(height: 20),
                      _buildAnimatedOrb(),
                      const SizedBox(height: 32),
                    ],
                    _buildInputField(busy),
                    const SizedBox(height: 16),
                    _buildConversationPreview(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildControls(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: SanctuaryTheme.primaryText, size: 18),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'SleepMate Voice',
                  style: GoogleFonts.nunito(
                    color: SanctuaryTheme.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your calm companion tonight',
                  style: GoogleFonts.quicksand(
                    color: SanctuaryTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAnimatedOrb() {
    final Color baseColor;
    switch (_state) {
      case VoiceState.idle:
        baseColor = SanctuaryTheme.accentYellow;
      case VoiceState.listening:
        baseColor = SanctuaryTheme.accentBlue;
      case VoiceState.thinking:
        baseColor = SanctuaryTheme.accentPink;
      case VoiceState.speaking:
        baseColor = SanctuaryTheme.accentOrange;
    }

    final scale = _scaleAnimation.value;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring 2
            Transform.scale(
              scale: scale * 1.25,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor.withValues(alpha: 0.03),
                  border: Border.all(
                    color: baseColor.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Outer pulse ring 1
            Transform.scale(
              scale: scale * 1.12,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor.withValues(alpha: 0.07),
                  border: Border.all(
                    color: baseColor.withValues(alpha: 0.22),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Main glowing orb
            Transform.scale(
              scale: scale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      baseColor.withValues(alpha: 0.8),
                      baseColor.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.3, 0.8, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withValues(alpha: 0.35),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.nightlight_round,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(bool busy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: _inputCtrl,
        enabled: !busy,
        style: GoogleFonts.quicksand(
          color: SanctuaryTheme.primaryText,
          fontSize: 14,
        ),
        onSubmitted: (val) {
          final text = val.trim();
          if (text.isNotEmpty && !busy) {
            _processUserMessage(text);
          }
        },
        decoration: InputDecoration(
          hintText: 'Type how you feel, or tap Talk to use voice...',
          hintStyle: GoogleFonts.quicksand(
            color: SanctuaryTheme.secondaryText.withValues(alpha: 0.7),
            fontSize: 13,
          ),
          filled: true,
          fillColor: SanctuaryTheme.cardBackground,
          prefixIcon: const Icon(Icons.edit_note_rounded,
              color: SanctuaryTheme.accentYellow, size: 22),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _inputCtrl,
            builder: (context, value, child) {
              if (value.text.trim().isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.send_rounded, color: SanctuaryTheme.accentYellow, size: 20),
                onPressed: busy ? null : () {
                  final text = _inputCtrl.text.trim();
                  if (text.isNotEmpty) {
                    _processUserMessage(text);
                  }
                },
              );
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SanctuaryTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: SanctuaryTheme.accentOrange),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildConversationPreview() {
    if (_lastUserText.isEmpty && _lastBotText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_lastUserText.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: SanctuaryTheme.cardBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                  border: Border.all(color: SanctuaryTheme.border),
                ),
                child: Text(
                  _lastUserText,
                  style: GoogleFonts.quicksand(
                    color: SanctuaryTheme.primaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          if (_lastBotText.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(14),
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F2937), Color(0xFF111827)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(
                    color: SanctuaryTheme.accentOrange.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  _lastBotText,
                  style: GoogleFonts.quicksand(
                    color: SanctuaryTheme.primaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final busy =
        _state == VoiceState.thinking || _state == VoiceState.speaking;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _SanctuaryActionButton(
              label: _state == VoiceState.listening ? 'Listening...' : 'Talk',
              icon: Icons.mic_rounded,
              colors: const [Color(0xFFFFC44D), Color(0xFFFFAD33)],
              onPressed: busy ? null : _onTapTalk,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _SanctuaryActionButton(
              label: 'Stop',
              icon: Icons.stop_rounded,
              colors: const [Color(0xFFE68868), Color(0xFFE07A5F)],
              onPressed: _state == VoiceState.speaking ? _stopSpeaking : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapTalk() async {
    if (_gemini == null) {
      setState(() {
        _statusText = 'Add GEMINI_API_KEY to sleep_ui/.env';
      });
      return;
    }

    String userText = _inputCtrl.text.trim();

    if (userText.isEmpty && _speechReady) {
      setState(() {
        _state = VoiceState.listening;
        _statusText = 'Listening...';
      });
      _syncOrbAnimation();

      await _speech.listen(
        onResult: (result) {
          _inputCtrl.text = result.recognizedWords;
          if (result.finalResult && mounted) {
            setState(() => _statusText = 'Got it. Thinking...');
          }
        },
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );

      await Future.delayed(const Duration(milliseconds: 500));
      while (_speech.isListening) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      userText = _inputCtrl.text.trim();
      await _speech.stop();
    }

    if (userText.isEmpty) {
      userText = 'I slept 5 hours last night and feel tired.';
      _inputCtrl.text = userText;
    }

    await _processUserMessage(userText);
  }

  Future<void> _processUserMessage(String userText) async {
    _inputCtrl.clear();
    setState(() {
      _state = VoiceState.thinking;
      _statusText = 'SleepMate is thinking...';
      _lastUserText = userText;
    });
    _syncOrbAnimation();

    try {
      final reply = await _gemini!.generateReply(userText);

      if (!mounted) return;
      setState(() => _lastBotText = reply);

      try {
        await SupabaseService.instance.saveAssistantSession(
          userMessage: userText,
          detectedMood: _guessMood(userText),
          assistantReply: reply,
          suggestedAction: _guessAction(userText),
        );
      } catch (dbError) {
        debugPrint('Failed to save session to Supabase: $dbError');
      }

      await _speak(reply);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = VoiceState.idle;
        _statusText = 'Assistant error: $e';
      });
      _syncOrbAnimation();
    }
  }

  Future<void> _speak(String text) async {
    setState(() {
      _state = VoiceState.speaking;
      _statusText = 'SleepMate is speaking...';
    });
    _syncOrbAnimation();
    await _tts.speak(text);
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    if (!mounted) return;
    setState(() {
      _state = VoiceState.idle;
      _statusText = 'Tap to talk to SleepMate';
    });
    _syncOrbAnimation();
  }

  String _guessMood(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('tired') || lower.contains('exhausted')) {
      return 'tired';
    }
    if (lower.contains('anxious') || lower.contains('stress')) {
      return 'anxious';
    }
    if (lower.contains('happy') || lower.contains('good')) {
      return 'calm';
    }
    return 'neutral';
  }

  String _guessAction(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('tired') || lower.contains('sleep')) {
      return 'Try a 20-minute wind-down routine before bed.';
    }
    if (lower.contains('stress') || lower.contains('anxious')) {
      return 'Try 4-7-8 breathing for 3 minutes.';
    }
    return 'Keep a consistent bedtime tonight.';
  }
}

class _SanctuaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onPressed;

  const _SanctuaryActionButton({
    required this.label,
    required this.icon,
    required this.colors,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(colors: colors),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black87, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
