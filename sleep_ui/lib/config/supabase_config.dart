import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sleep_ui/config/supabase_secrets.dart';

class SupabaseConfig {
  static const _urlDefine = String.fromEnvironment('SUPABASE_URL');
  static const _anonKeyDefine = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Removes stray whitespace, quotes, and trailing '=' that break DNS lookup.
  static String sanitizeUrl(String raw) {
    var value = raw.trim();
    if (value.startsWith('"') || value.startsWith("'")) {
      value = value.substring(1);
    }
    if (value.endsWith('"') || value.endsWith("'")) {
      value = value.substring(0, value.length - 1);
    }
    value = value.trim();
    while (value.endsWith('=')) {
      value = value.substring(0, value.length - 1).trim();
    }
    return value;
  }

  static String sanitizeKey(String raw) => raw.trim();

  static Future<void> loadEnv() async {
    await dotenv.load(fileName: '.env');
  }

  static String get url {
    if (_urlDefine.isNotEmpty) return sanitizeUrl(_urlDefine);
    final fromEnv = dotenv.env['SUPABASE_URL'];
    if (fromEnv != null && fromEnv.isNotEmpty) return sanitizeUrl(fromEnv);
    return SupabaseSecrets.url;
  }

  static String get anonKey {
    if (_anonKeyDefine.isNotEmpty) return sanitizeKey(_anonKeyDefine);
    final fromEnv = dotenv.env['SUPABASE_ANON_KEY'];
    if (fromEnv != null && fromEnv.isNotEmpty) return sanitizeKey(fromEnv);
    return SupabaseSecrets.anonKey;
  }

  static bool get isValid {
    final u = url;
    final k = anonKey;
    return u.startsWith('https://') &&
        u.contains('.supabase.co') &&
        !u.contains('YOUR-PROJECT-ID') &&
        k.isNotEmpty &&
        k != 'YOUR-ANON-PUBLIC-KEY';
  }
}
