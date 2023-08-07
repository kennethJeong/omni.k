// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> get_contents_kpops() async {
  const apiUrl = 'https://circlechart.kr/data/api/chart/global';
  http.Response response = await http.post(
    Uri.parse(apiUrl),
    body: {
      'termGbn': 'day',
      'yyyymmdd': '20230724',
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
  );

  List<Map<String, String>> list = [];
  Map<String, dynamic> res = jsonDecode(utf8.decode(response.bodyBytes))['List'];
  for(var i=0; i<res.length; i++) {
    final dataSet = res['$i'];
    String title = dataSet['Title'];
    String artist = dataSet['Artist'];
    String image = 'https://circlechart.kr/uploadDir/${dataSet['ALBUMIMG']}';
    String link = 'https://www.youtube.com/results?search_query=$artist $title';

    list.add({
      'title': title,
      'artist': artist,
      'image': image,
      'link': link,
    });
  }

  return list;
}