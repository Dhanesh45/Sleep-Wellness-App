import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sleep_ui/config/supabase_config.dart';

void main() async {
  await SupabaseConfig.loadEnv();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final res = await Supabase.instance.client.from('story_audio_versions').select('storyid, voiceid, audio_path');
  print('Audio versions: $res');
}
