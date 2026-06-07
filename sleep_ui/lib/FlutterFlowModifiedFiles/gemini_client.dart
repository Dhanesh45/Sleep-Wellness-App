import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiClient {
  GeminiClient(this.apiKey);

  final String apiKey;

  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String> generateReply(String userMessage) async {
    final uri = Uri.parse('$_baseUrl?key=$apiKey');

    final body = {
      'contents': [
        {
          'parts': [
            {
              'text':
                  'You are SleepMate, a friendly sleep and wellness assistant for the Restora app. '
                  'Reply in 2-4 short sentences. Be warm, practical, and calming. '
                  'User says: $userMessage',
            },
          ],
        },
      ],
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini error: ${response.statusCode} ${response.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No candidates from Gemini');
    }

    final first = candidates.first as Map<String, dynamic>;
    final content = first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    final text = (parts.first as Map<String, dynamic>)['text'] as String?;

    if (text == null || text.isEmpty) {
      throw Exception('Empty text from Gemini');
    }

    return text.trim();
  }
}
