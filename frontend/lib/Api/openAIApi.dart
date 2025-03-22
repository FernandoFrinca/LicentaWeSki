import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;

import 'consts.dart';

class OpenAiApi {
  final String apiKey =openAiApi;
  Future<String> responseFromOpenAi(String pronto) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content':
            'Raspund doar la intrebari legate de ski, snowboard, sporturi de iarna, resorturi de ski, locatiile acestora, distante legate de partii, doar chestii specifice pentru echipamente de iarna si sporturi de iarna, indiferent de limba în care sunt puse întrebările.'
          },
          {'role': 'user', 'content': '$pronto'}
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response from ChatGPT');
    }
  }
}