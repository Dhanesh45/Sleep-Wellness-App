  import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      await client.from('users').insert({
        'auth_user_id': user.id,
        'email': email,
        if (fullName != null && fullName.isNotEmpty) 'fullname': fullName,
      });
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<int?> getCurrentUserId() async {
    final user = currentUser;
    if (user == null) return null;

    final profile = await client
        .from('users')
        .select('userid')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (profile == null) return null;
    return profile['userid'] as int?;
  }

  Future<void> saveAssistantSession({
    required String userMessage,
    required String detectedMood,
    required String assistantReply,
    required String suggestedAction,
  }) async {
    final user = currentUser;
    if (user == null) return;

    final profile = await client
        .from('users')
        .select('userid')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (profile == null) return;

    await client.from('assistant_sessions').insert({
      'userid': profile['userid'],
      'user_message': userMessage,
      'detected_mood': detectedMood,
      'assistant_reply': assistantReply,
      'suggested_action': suggestedAction,
    });
  }

  Future<List<Map<String, dynamic>>> fetchRecommendations() async {
    final user = currentUser;
    if (user == null) return [];

    final profile = await client
        .from('users')
        .select('userid')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (profile == null) return [];

    final List<dynamic> data = await client
        .from('recommendations')
        .select('*')
        .eq('userid', profile['userid'])
        .order('generatedat', ascending: false);

    return data.cast<Map<String, dynamic>>();
  }
}
