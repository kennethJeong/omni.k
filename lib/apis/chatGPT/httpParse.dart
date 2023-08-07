import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/models/state_notifier.dart';

Future<String> completionText(String prompt) async {
  final apiKey = FlutterConfig.get('apiKey_chatGPT');
  const apiUrl = 'https://api.openai.com/v1/completions';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    },
    body: jsonEncode({
      'model': 'text-davinci-003',
      'prompt': prompt,
      'max_tokens': 1000,
      'temperature': 0,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0
    }),
  );

  Map<String, dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));

  return res['choices'][0]['text'];
}

/////////////////////////////////////////////////////////////////////////////////

Future<String> completionChat(WidgetRef ref, String prompt) async {
  final messageRecords = ref.watch(chatProvider);

  // for(var i=0; i<messageRecords.length; i++) {
  //   print(messageRecords[i].answer);
  // }

  final apiKey = FlutterConfig.get('apiKey_chatGPT');
  const apiUrl = 'https://api.openai.com/v1/chat/completions';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages' : [
        {
          "role": "system",
          "content": "You are a Korean teacher who only knows about Korea.",
        },
        {
          "role": "assistant",
          "content": messageRecords.isNotEmpty ? messageRecords.last.answer : '',
        },
        {
          "role": "user",
          "content": prompt,
        },
      ],
      'max_tokens': 500,
      'temperature': 0.7,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0
    }),
  );

  Map<String, dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));

  return res['choices'][0]['message']['content'];
}



