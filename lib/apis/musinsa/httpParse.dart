// ignore_for_file: non_constant_identifier_names
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

Future<List<Map<String, String>>> get_contents_musinsa() async {
  int randomPageNum_brandsnap = Random().nextInt(500);
  // int randomPageNum_streetsnap = Random().nextInt(30);
  const url = 'https://www.musinsa.com';
  final urlExtension_brandsnap = '/mz/brandsnap?_m=&gender=&mod=&bid=&p=$randomPageNum_brandsnap';
  // final urlExtension_streetsnap = '/mz/streetsnap?_mon=&gender=&p=$randomPageNum_streetsnap#listStart';
  final List<String> listTypes = [
    urlExtension_brandsnap,
    // urlExtension_streetsnap,
  ];
  String randomListTypeUrl = listTypes[Random().nextInt(listTypes.length)];

  final apiUrl = url + randomListTypeUrl;
  http.Response response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  dom.Document document = parser.parse(response.body);

  List<Map<String, String>> listItem = [];
  List<dom.Element> elementsByClassName = document.querySelectorAll('.articleImg');
  for (var element in elementsByClassName) {
    String? linkTemp = element.querySelector('a')?.attributes['href'];
    String? img = element.querySelector('img')?.attributes['src'];
    String link = url + linkTemp!;

    listItem.add({
      'link': link,
      'img': img!,
    });
  }

  return listItem;
}