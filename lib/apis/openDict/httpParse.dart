import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

Future<String> getOpenDict(String word) async {
  final openDictKrKey = FlutterConfig.get('opendict_kr_Key');

  Map<String, String> queryParameters = {
    'key': openDictKrKey,
    'req_type': 'json',
    'part': 'word',
    'sort': 'dict',
    'advanced': 'y',
    'q': word,
  };

  final uri = Uri.https('opendict.korean.go.kr', '/api/search', queryParameters);
  final response = await http.get(uri);

  Map<String, dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));

  return res['channel']['item'][0]['sense'][0]['definition'];
}
