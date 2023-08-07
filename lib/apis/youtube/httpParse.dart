// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> get_contents_youtube(String keyword, String relatedToVideoId) async {
  DateTime dateTimeToday = DateTime.now();
  DateTime dateTimeThreeMonthsAgo = dateTimeToday.subtract(
    const Duration(days: 90)     // Get contents from 3 months ago
  );
  String today = dateTimeToday.toUtc().toIso8601String();
  String threeMonthsAgo = dateTimeThreeMonthsAgo.toUtc().toIso8601String();

  final apiKey = FlutterConfig.get('apiKey_youtube');
  const url = 'https://www.googleapis.com';
  const urlExtension = '/youtube/v3/search?';
  List<String> urlFields = [
    'part=snippet',
    'maxResults=50',
    'order=relevance',
    'publishedAfter=$threeMonthsAgo',
    'publishedBefore=$today',
    'q=$keyword',
    'regionCode=kr',
    // 'relatedToVideoId=$relatedToVideoId',
    'safeSearch=strict',
    'videoEmbeddable=true',
    'videoSyndicated=true',
    'videoDefinition=high',
    'type=video',
    'videoDuration=medium',
    'key=$apiKey'
  ];
  final apiUrl = url + urlExtension + urlFields.join('&');

  http.Response response = await http.get(
    Uri.parse(apiUrl),
  );

  List<Map<String, String>> list = [];
  List<dynamic> res = jsonDecode(response.body)['items'];

  if(res.isNotEmpty) {
    for(var i=0; i<res.length; i++) {
      final videoId = res[i]['id']['videoId'];
      final itemArray = res[i]['snippet'];
      String videoTitle = itemArray['title'].replaceAll('&#39', '\'').replaceAll(';', '');
      String videoThumbnail = itemArray['thumbnails']['high']['url'];
      String videoLink = 'https://www.youtube.com/watch?v=$videoId';

      list.add({
        'title': videoTitle,
        'img': videoThumbnail,
        'link': videoLink,
      });
    }
  } else {
    print("Error Connection");
  }

  return list;
}