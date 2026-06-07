import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sleep_ui/config/gemini_secrets.dart';

class GeminiConfig {
  static const _keyDefine = String.fromEnvironment('GEMINI_API_KEY');

  static String get apiKey {
    if (_keyDefine.isNotEmpty) return _keyDefine.trim();
    final fromEnv = dotenv.env['GEMINI_API_KEY'];
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv.trim();
    return GeminiSecrets.apiKey;
  }

  static bool get isConfigured =>
      apiKey.isNotEmpty && apiKey != 'YOUR_GEMINI_API_KEY';
}
