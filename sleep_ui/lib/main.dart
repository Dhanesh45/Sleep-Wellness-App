import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sleep_ui/FlutterFlowModifiedFiles/restora_login_screen.dart';
import 'package:sleep_ui/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseConfig.loadEnv();
    debugPrint('dotenv loaded from .env asset');
  } catch (e) {
    debugPrint('dotenv load failed, using hardcoded SupabaseSecrets: $e');
  }

  final supabaseUrl = SupabaseConfig.url;
  final supabaseAnonKey = SupabaseConfig.anonKey;

  debugPrint('SUPABASE_URL used by app: $supabaseUrl');
  debugPrint(
    'SUPABASE_ANON_KEY present: ${supabaseAnonKey.isNotEmpty} '
    '(length ${supabaseAnonKey.length})',
  );

  if (!SupabaseConfig.isValid) {
    debugPrint('ERROR: Supabase URL or key is missing or still a placeholder.');
    runApp(const MyApp(supabaseReady: false));
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    debugPrint('Supabase.initialize completed successfully');
  } catch (e, stack) {
    debugPrint('Supabase.initialize failed: $e');
    debugPrint('$stack');
    runApp(const MyApp(supabaseReady: false, initError: true));
    return;
  }

  runApp(const MyApp(supabaseReady: true));
}

class MyApp extends StatelessWidget {
  final bool supabaseReady;
  final bool initError;

  const MyApp({
    super.key,
    required this.supabaseReady,
    this.initError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!supabaseReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _SupabaseSetupScreen(initError: initError),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restora',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C0F14),
        useMaterial3: true,
      ),
      home: const RestoraLoginScreen(),
    );
  }
}

class _SupabaseSetupScreen extends StatelessWidget {
  final bool initError;

  const _SupabaseSetupScreen({this.initError = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Setup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              initError
                  ? 'Supabase failed to initialize'
                  : 'Supabase credentials are invalid',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Open Supabase Dashboard → Project Settings → API\n'
              '2. Copy Project URL and Publishable key into sleep_ui/.env\n'
              '   or lib/config/supabase_secrets.dart\n'
              '3. URL must be exactly: https://YOUR-ID.supabase.co\n'
              '   (no trailing = or spaces)\n'
              '4. Run: flutter clean && flutter pub get && flutter run\n'
              '5. Check logcat for: SUPABASE_URL used by app',
            ),
          ],
        ),
      ),
    );
  }
}
