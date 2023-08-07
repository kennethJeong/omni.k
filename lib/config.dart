// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

Future<void> writeConfig(String sort, String writeValue) async {
  final directory = (await getApplicationDocumentsDirectory ()).path;
  const String dirConfig = 'config';

  if(sort == "newsroom") {
    const String file_NewsRoomContentShowLimit = '$dirConfig/newsRoomContentsShowLimit.txt';
    final String path_NewsRoomContentShowLimit = '$directory/$file_NewsRoomContentShowLimit';
    String value = writeValue;   // Json -> String

    File(path_NewsRoomContentShowLimit).writeAsString(value);
  }
  else if(sort == "darkmode") {
    const String file_DarkMode = '$dirConfig/darkMode.txt';
    final String path_DarkMode = '$directory/$file_DarkMode';
    String value = writeValue;   // int -> String

    File(path_DarkMode).writeAsString(value);
  }
}

Future<dynamic> readConfig(String sort) async {
  final directory = (await getApplicationDocumentsDirectory ()).path;
  const String dirConfig = 'config';
  dynamic result;

  if(sort == "newsroom") {
    // [News Room] -> Number of each platform content to initially show to the user.
    const String file_NewsRoomContentShowLimit = '$dirConfig/newsRoomContentsShowLimit.txt';
    final String path_NewsRoomContentShowLimit = '$directory/$file_NewsRoomContentShowLimit';

    result = Map<String, int>.from(jsonDecode(await File(path_NewsRoomContentShowLimit).readAsString()));
  }
  else if(sort == "darkmode") {
    // [ Theme ] -> Dark Mode
    const String file_DarkMode = '$dirConfig/darkMode.txt';
    final String path_DarkMode = '$directory/$file_DarkMode';

    result = int.parse(await File(path_DarkMode).readAsString());
  }

  return result;
}


Future<void> initWriteConfig(WidgetRef ref, String dir) async {
  final directory = dir;
  const String dirConfig = 'config';

  //
  // [News Room] -> Number of each platform content to initially show to the user.
  const String file_NewsRoomContentShowLimit = '$dirConfig/newsRoomContentsShowLimit.txt';
  final String path_NewsRoomContentShowLimit = '$directory/$file_NewsRoomContentShowLimit';
  Map<String, int> newsRoomContentsShowLimit = {
    'facebook': 0,
    'tiktok': 2,      // range 1 ~ 3
    'instagram': 1,   // fixed
    'netflix': 2,     // range 1 ~ 3
    'youtube': 1,     // range 1 ~ 2
    'musinsa': 5,     // range 5 ~ 15
    'kpops': 2,       // range 2 ~ 5
  };
  final jsonNewsRoomContentsShowLimit = jsonEncode(newsRoomContentsShowLimit);
  File(path_NewsRoomContentShowLimit).writeAsString(jsonNewsRoomContentsShowLimit);
  //

  //
  // [ Theme ] -> Dark Mode
  const String file_DarkMode = '$dirConfig/darkMode.txt';
  final String path_DarkMode = '$directory/$file_DarkMode';
  int init_DarkMode = 0;

  File(path_DarkMode).writeAsString(init_DarkMode.toString());
  //

  print("<<Processing>> initWriteConfig");
}

Future<void> initConfig(WidgetRef ref) async {
  // config 디렉토리 생성 => [ /data/user/0/com.example.omni_k/app_flutter ]
  final directory = (await getApplicationDocumentsDirectory ()).path;
  String dirConfig = 'config';

  if(await Directory("$directory/$dirConfig").exists() == false) {
    Directory("$directory/$dirConfig").create(recursive: true).then((value) {
      print("<<Processing>> initConfig => Directory Created !!");

      initWriteConfig(ref, directory);
    });

    print("<<Processing>> initConfig => Create=True");
  } else {
    print("<<Processing>> initConfig => Create=False");
  }
}

// 디렉토리 or 파일 -> 생성 함수
// 파일(txt) -> 읽기&쓰기 함수
// [news_room] -> 타임라인 -> 컨텐츠 수 조정하기.
// [see_more] -> 다크모드 온오프.

