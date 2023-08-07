// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

Future<Map<String, dynamic>> get_contents_instagram() async {
  // const r1 = 'hkXvbBToMOQntXhXZtLOfQ9XCAA6oNjHRySHWxNjJznMP0wjS8SRu%2F4L6trmTVhw0ZoRKOQgCTSq8rO8OJF1d9zZ7TxTIxiLiF6OkCho22Fx6jKmKae4jW6IzEwuiTS%2BMfK2sx%2F0Fcbb0IYRRLOr6pS4tQG8bMOpCS2mx%2B%2BClQ4%3D';
  const url_noxinfluencer_rank = 'https://kr.noxinfluencer.com/api/instagram/channel/rank?type=followers&interval=weekly&country=KR&category=0&pageNum=1';
  List<Map<String, dynamic>> list = [];
  List<String> listName = [];

  Map<String, String> httpHeaders = {
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'ko,en;q=0.9,en-US;q=0.8',
    'Cache-Control': 'max-age=0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Cookie': 'firstLogin=false; cookie_utm_source=null; cookiePrivacy=true; NSESSID=s%3AYZmolVFRo8FNhYuQiljxGG6MZnCTEMIw.xmtmAnI6azZdX8Ku3Z3Cz4LPlxrwr5JgaXORXBT3XrY;',
  };

  await http.get(
    Uri.parse(url_noxinfluencer_rank),
    headers: httpHeaders,
  ).then((value) async {
    String html_noxinfluencer_rank = jsonDecode(value.body)['dom'];
    dom.Document document = parser.parse(html_noxinfluencer_rank);

    List<dom.Element> elementsByClassName = document.querySelectorAll('.link.clearfix');
    for (var element in elementsByClassName) {
      String? img = element.querySelector('.avatar')?.attributes['src'];
      String? name = element.querySelector('.title')?.text;
      String? channelID = element.attributes['href']?.split('/').last;

      if(listName.isNotEmpty || !listName.contains(name)) {
        listName.add(name!);
        list.add({
          'name': name,
          'img': img,
          'channel_id': channelID,
        });
      }
    }

    // Get followers
    //
    List<dom.Element> elementsByClassName_2 = document.querySelectorAll('.rank-cell.rank-followers');
    for (var i=0; i<elementsByClassName_2.length; i++) {
      dom.Element element = elementsByClassName_2[i];
      String? followers = element.querySelector('.number')?.text;
      if(followers!.isNotEmpty) {
        list[i]['followers'] = followers.replaceAll("만", "m");
      }
    }
  });

  // 전체 리스트 (100개)에서 하나만 랜덤 추출
  //
  final randomNum = Random().nextInt(list.length);
  Map<String, dynamic> randomItem = list[randomNum];    // 랜덤 Item
  String randomChannelID = randomItem['channel_id'];

  // Get instagram ID & link
  //
  final url_noxinfluencer_info_with_channelID = 'https://kr.noxinfluencer.com/ws/instagram/star/baseInfo?channelId=$randomChannelID';
  await http.get(
    Uri.parse(url_noxinfluencer_info_with_channelID),
    headers: httpHeaders,
  ).then((v){
    randomItem['instagram_id'] = jsonDecode(v.body)['retData']['alias'];
    randomItem['link'] = 'https://www.instagram.com/${randomItem['instagram_id']}/';
  });

  Map<String, dynamic> item = randomItem;
  return item;
}


///////////
// instagram 공식 api 사용+개발하려 했지만 실패. (이유 -> 토큰,코드 사용 및 주기적인 업데이트 필수 & 앱 검수 필요 & 공식 문서의 난해함 등)
// ↓ ↓ ↓ ↓

// class InstagramData {
//   final String appID = '800745271402058';
//   final String appSecretCode = 'd61f8543b7090d2a449a46da73ffd6d2';
//   final String redirectUri = 'https://omni-k.kr/auth/';
//   final String igMyId = '9498943350176223';
//
//   final String accessToken_short = 'EAALYRgl1HkoBACBFkgU4ysQo5cWQXR8ZCZBl9nZBvO8HwfxDNgcq7SFuQs1HNTdgt3XK4h6E2HSWfpTYWeHrZCdksESMw4ZCJcaZBpGaumnxZB0OGNnzfxLcFwd1ZBx8vKefa6ZBy4IjIZCj868ZA1n5d1RCp8GcbzSDG5zxhZB3VQYPN3W2FtJS0IbsXoerNt7D6M58iQFvUtpvokw0kyfiy7r3ZBc6tB9svtsRDLrYujJUTZCgZDZD';
//   final String accessToken_long = 'EAALYRgl1HkoBAD7dN7CaZBCqzpy4KtCNgdZBQHSKcZBFpYSkv4kQQOTMUQCiIwyVZCBXARD7ZCZBcpqUZArM94ZCTDvgxLw2DPUCkCZAQin2skTFbugrZAF3ZBg9HPjFUaSAZBVFo4Hyico32bb13unNYSxYP70LiWxK3lvliZCZBXZB96XDqLUR8aSDmJ2W2ckkyRAbsUZD';
// }
//
// Future<String> get_accessToken_userID_instagram(WidgetRef ref) async {
//   final url_user_authorize_code = 'https://l.instagram.com/?u=https%3A%2F%2Fomni-k.kr%2Fauth%2F%3Fcode%3DAQDG4ZCI80Eq6AnK2S_uAOdMyJJyx7ggsHW8ebJtTFwmngc36kvaOSyCPw2X5fyjq94RqDzilLkZBnWS6lRVAkvu8XVKMq1FaNeLtiMM8hh7f5OiHE4H7QBE_glbN7-2mVppTLrod5xH6K_Xuv-r6hqC05a8UVtuSJeTHBmfD0mvKC3R5by1gWDOntXyAibZsq36BEeJxqBCYiQfMyAhtuKXQ9eVSxzDj05wc2B4U9hSQQ%23_&e=AT3qaIw0NQMLidQMPbJBkjJLS-Sa9FdMyTZR5SrU3iIlKegVn5oUnkL-6x94V75jyx9C8YmiVVB1iQEEFz_IKCWd3exrnFvaE7X7aQ';
//   final url_user_authorize = 'https://api.instagram.com/oauth/authorize?client_id=${InstagramData().appID}&redirect_uri=${InstagramData().redirectUri}&scope=user_profile,user_media&response_type=code';
//   final url_accessToken_and_userID = 'https://api.instagram.com/oauth/access_token';
//
//
//   late String authorize_code;
//   await http.get(
//     Uri.parse(url_user_authorize_code),
//   ).then((value){
//     String res_user_authorize_code = value.body;
//     String authorizeCode = res_user_authorize_code.split('("')[1].split('#_")')[0].split('?code=')[1];
//     authorize_code = authorizeCode;
//   });
//
//
//   authorize_code = 'AQAkRL3vnBR4OsCahX6eA1yVGAMFCFK1RUqTs4K1vyiSJUXdRuWjsUo4qGc_DrQGYDs_f4zRfJ3lPEPbwI0Ab97hY2kJ2aaC-mUm6AX3ZjSyNDtjeZuBppMfAdBzL28s3yPff57X35zDaeYgutUZ6OcqT7SjUQDin1rvpM5btW0Q5TCHLNG8dp0ayieCIaahRxzulgwzuMeyVY7ogD_TY8db9CQK8iUQmE9zOVK51Cie8g';
//
//
//
//   final response_accessToken_and_userID = await http.post(
//     Uri.parse(url_accessToken_and_userID),
//     body: {
//       'client_id': InstagramData().appID,
//       'client_secret': InstagramData().appSecretCode,
//       'grant_type': 'authorization_code',
//       'redirect_uri': InstagramData().redirectUri,
//       'code': authorize_code,
//     },
//   );
//
//   Map<String, dynamic> res_accessToken_and_userID = jsonDecode(response_accessToken_and_userID.body);
//
//
//   final accessToken = 'IGQVJVeU1yWXNlaUtScFpGTV9aSWQ4UTVHdmxBdGQ2MWMyWVR1S1hmeEFtcThMMGNBank0NndZAZA1gwQ21qU0ZAjR3MyMEE0OTgwa3RraEc1YzZAjLU9SWVotREdmNGRnTnpBdUNGcDFGSm8xdkVmWEY0R2xaQnZAETXVlSG5F';
//   final igMyId = '6190167361037532';
//
//
//   final url_username = 'https://graph.instagram.com/$igMyId?fields=id,username&access_token=$accessToken';
//
//   await http.get(
//     Uri.parse(url_username),
//   ).then((value){
//     String username = jsonDecode(value.body)['username'];
//   });
//
//
//   final r = "";
//   return r;
//
// }
//
// Future<String> refresh_access_token_instagram(String access_token_long) async {
//   final url = 'https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&access_token=$access_token_long';
//   late String refreshed_access_token_long;
//   await http.get(
//     Uri.parse(url),
//   ).then((value){
//     refreshed_access_token_long = jsonDecode(value.body)['access_token'];
//   });
//
//   return refreshed_access_token_long;
// }









// var url = 'https://www.instagram.com/web/search/topsearch/?context=user&count=0&query=$ig_username';

//   final url_ig_exchange_token_short_to_long =
//       'https://graph.instagram.com/access_token?grant_type=ig_exchange_token'
//           + '&client_secret=${InstagramData().appSecretCode}'
//           + '&access_token=${InstagramData().accessToken_short}';
//
//   late String access_token_long;
//   await http.get(
//     Uri.parse(url_ig_exchange_token_short_to_long),
//   ).then((value){
//     access_token_long = jsonDecode(value.body)['access_token'];
//   });


// String access_token_long = InstagramData().accessToken_long;
// String ig_my_id = InstagramData().igMyId;
//
// String ig_username = 'jennierubyjane';
//
// final url_business_discorvery = 'https://graph.facebook.com/$ig_my_id'
//   +'?fields=business_discovery.username($ig_username)'
//   +'{media}'
//   +'&access_token=$access_token_long';
//
// late String ig_user_id;
// late List<Map<String, dynamic>> ig_user_data;
//
// await http.get(
//   Uri.parse(url_business_discorvery),
// ).then((value){
//   Map<String, dynamic> ig_user_media = jsonDecode(value.body);
//   print(ig_user_media);
//   // ig_user_id = ig_user_media['id'];
//   // ig_user_data = ig_user_media['data'];
// });


////
////
// final client = HttpClient();
// var uri = Uri.parse(url);
// var request = await client.getUrl(uri);
// request.followRedirects = false;
// var response = await request.close();
// while (response.isRedirect) {
//   response.drain();
//   final location = response.headers.value(HttpHeaders.locationHeader);
//   if (location != null) {
//     uri = uri.resolve(location);
//     request = await client.getUrl(uri);
//     // Set the body or headers as desired.
//     request.followRedirects = false;
//     request.headers.add("Content-type", "application/json");
//     request.cookies.add(Cookie("sessionid", "3089036951%3AH04iwYJ2dOZ5p4%3A1%3AAYeyp-zIqSeiT592NGUyKGr44ICpVrp_PpZNm2aFSQ"));
//
//     response = await request.close();
//
//   }
// }
//
// response.transform(utf8.decoder).listen((body) {
//   if(!body.contains('"status":"fail"')) {
//     print(body);
//   } else {
//     print("error");
//   }
// });
