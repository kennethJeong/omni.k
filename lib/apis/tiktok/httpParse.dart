// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> get_contents_tiktok(String keyword) async {
  const url = 'https://www.tiktok.com';   // 무조건 https 필요
  const urlExtension = '/api/search/general/full/?';
  List<String> urlFields = [
    'aid=1988',
    'offset=0',
    'app_language=ko-KR',
    'region=KR',
    // 'priority_region=VN',
    'tz_name=Asia/Seoul',
    'cookie_enabled=true',
    'from_page=search',
    'screen_height=',
    'screen_width=',
    'keyword=$keyword',
    'max_count=15',
    // [msToken] => 무조건 url에 붙어있어야함.
    'msToken=yET0jNKvGC8BoZ2S63lRdCCb6mzGdMVuaZNag5U2uwrjhKIllxnVn61ulKjSP_UGWKn48wt6CxInvaiOPmwhMYiwxoj4V1gxAYYyuSJZ9bBDnxVoMHO6UhiPa0a8MNPw_OjSNeDcvZW3eGZy_A==',
  ];
  var apiUrl = url + urlExtension + urlFields.join('&');
  List<String> listCookie = [
    // [ttwid] => 무조건 cookie에 붙어있어야함.
    'ttwid=1%7CewNI7KeQPEgXINUlZNAh9MgpH5KIBLSd92C9xEQjX1s%7C1687413453%7C4e9857d413f2f57c487b74d691fcbfa95ce4271d3aa87ea5eaab70b30266758b;'
  ];
  String cookie = listCookie.join('');
  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Encoding': 'UTF-8',
      'cookie': cookie,
    },
  );

  List<Map<String, String>> list = [];
  List<dynamic> res = jsonDecode(response.body)['data'];
  if(res.isNotEmpty) {
    for(var i=0; i<res.length; i++) {
      final itemArray = res[i]['item'];
      String videoTitle = itemArray['desc'];
      String videoId = itemArray['video']['id'];
      String videoThumbnail = itemArray['video']['cover'];
      String authorUniqueId = itemArray['author']['uniqueId'];

      String videoLink = 'https://www.tiktok.com/@$authorUniqueId/video/$videoId';

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

//////// Official Tiktok api -> 지금은 US에서만 제공한다고 함. ////////
//
// Future<String> get_access_token_tiktok() async {
//   final apiKey = FlutterConfig.get('tiktok_client_Key');
//   final apiSecret = FlutterConfig.get('tiktok_client_Secret');
//   const apiUrl = 'https://open.tiktokapis.com/v2/oauth/token/';
//
//   var request = http.Request('POST', Uri.parse(apiUrl));
//
//   var headers = {
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   request.bodyFields = {
//     'client_key': apiKey,
//     'client_secret': apiSecret,
//     'grant_type': 'client_credentials',
//   };
//   request.headers.addAll(headers);
//
//   http.StreamedResponse response = await request.send();
//   final res = await response.stream.bytesToString();
//   Map<String, dynamic> resJson = jsonDecode(res);
//
//   return resJson['access_token'];
// }
//
// Future<Map<String, dynamic>> get_content_tiktok(WidgetRef ref, String accessToken) async {
//   // ref.read(provider_access_token_tiktok.notifier).state = '';
//
//   // var res = <String, dynamic>{};
//
//   DateTime dateTimeToday = DateTime.now();
//   String today = DateFormat('yyyyMMdd').format(dateTimeToday);
//   DateTime dateTimeTwoWeeksAgo = DateTime.now().subtract(
//       const Duration(days: 14)); // Get contents from 3 weeks ago
//   String twoWeeksAgo = DateFormat('yyyyMMdd').format(dateTimeTwoWeeksAgo);
//
//   const apiUrlBase = 'https://open.tiktokapis.com/v2/research/video/query/?';
//   const apiUrlFields = 'fields=video_id,video_description,create_time';
//   const apiUrl = apiUrlBase + apiUrlFields;
//
//   Map<String, dynamic> requestBody = {
//     "query": {
//       "and": [
//         {
//           // EQ(=), GT(>), GTE(>=), LT(<), LTE(<=), IN(Specified In an Array)
//           "operation": "IN",
//           "field_name": "region_code",
//           "field_values": [
//             "KR"
//           ]
//         },
//       ],
//       "or": [],
//       "not": [],
//     },
//     "max_count": 100,
//     "cursor": 100,
//     'start_date': twoWeeksAgo,
//     'end_date': today,
//   };
//
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {
//       'Content-Type': 'Application/json',
//       'Authorization': 'Bearer $accessToken',
//     },
//     body: jsonEncode(requestBody),
//   );
//
//   final res = jsonDecode(response.body);
//
//   return res;
// }
