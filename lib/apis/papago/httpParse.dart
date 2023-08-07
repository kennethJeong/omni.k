// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<String> getLanguage_papago(WidgetRef ref, String prompt) async {
  final naverClientId = FlutterConfig.get('naver_client_Id');
  final naverClientPw = FlutterConfig.get('naver_client_Secret');
  String contentType = "application/x-www-form-urlencoded; charset=UTF-8";
  String apiUrl = "https://openapi.naver.com/v1/papago/detectLangs";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': contentType,
      'X-Naver-Client-Id': naverClientId,
      'X-Naver-Client-Secret': naverClientPw,
    },
    body: {
      'query': prompt,
    },
  );

  final res = jsonDecode(response.body);

  return res['langCode'];
}

Future<String> getTranslation_papago(WidgetRef ref, String prompt) async {
  final naverClientId = FlutterConfig.get('naver_client_Id');
  final naverClientPw = FlutterConfig.get('naver_client_Secret');
  String contentType = "application/x-www-form-urlencoded; charset=UTF-8";
  String apiUrl = "https://openapi.naver.com/v1/papago/n2mt";

  String getLanguage = await getLanguage_papago(ref, prompt);
  Map<String, String> queryParameters = {
    'source': getLanguage,
    'target': 'ko',
    'text': prompt,
  };

  if (getLanguage == 'ko') {
    queryParameters['target'] = 'vi';
  }

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': contentType,
      'X-Naver-Client-Id': naverClientId,
      'X-Naver-Client-Secret': naverClientPw,
    },
    body: queryParameters,
  );

  final res = jsonDecode(response.body);

  return res['message']['result']['translatedText'];
}