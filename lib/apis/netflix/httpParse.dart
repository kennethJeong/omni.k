// ignore_for_file: non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

Future<List<Map<String, String>>> get_contents_netflix(String genre) async {
  var genreCode = '';
  switch(genre) {
    case 'drama': genreCode = '2638104'; break;
    case 'movie': genreCode = '5685'; break;
  }
  final apiUrl = 'https://www.netflix.com/kr/browse/genre/$genreCode';

  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Transfer-Encoding': 'chunk',
      'Encoding': 'UTF-8'
    },
  );
  dom.Document document = parser.parse(response.body);
  List<dom.Element> elementsByClassName = document.querySelectorAll('.nm-collections-title.nm-collections-link');

  List<Map<String, String>> list = [];
  List<String> listElementTitle = [];
  for (var element in elementsByClassName) {
    String? title = element.querySelector('.nm-collections-title-name')?.text;
    String? img = element.querySelector('.nm-collections-title-img')?.attributes['src'];
    String? link = element.attributes['href'];

    String imageSrc = '';
    if(img!.startsWith('http')) {
      imageSrc = img;
    }

    if(!listElementTitle.contains(title) && imageSrc.isNotEmpty && link != null) {
      listElementTitle.add(title!);

      list.add({
        'title': title,
        'img': imageSrc,
        'link': link,
      });
    }
  }

  return list;
}


// Future<String> get_contents_reviews_netflix(String contentTitle) async {
//   final getContentIdUrl = 'https://v3.sg.media-imdb.com/suggestion/x/$contentTitle.json?includeVideos=1';
//
//   http.Response getContentId = await http.get(
//     Uri.parse(getContentIdUrl),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//   );
//   final String contentId = jsonDecode(getContentId.body)['d'][0]['id'];
//   final String getContentReviewsUrl = 'https://www.imdb.com/title/$contentId/reviews';
//
//   return getContentReviewsUrl;
// }