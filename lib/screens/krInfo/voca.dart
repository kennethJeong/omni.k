import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/apis/papago/httpParse.dart';
import 'package:omni_k/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:omni_k/models/state_provider.dart';
import 'package:text_to_speech/text_to_speech.dart';


// ignore: must_be_immutable
class Voca extends HookConsumerWidget {
  Voca({super.key});

  var adCountRefresh = 0;

  // 엑셀파일로부터 한글 단어 리스트 가져오기
  Future<String> getRandomKrWord() async {
    ByteData data = await rootBundle.load('assets/krWords/kr_words.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    Sheet sheet = excel['words'];

    List<String> listKrWords = [];

    for(var i=0; i<sheet.maxRows; i++) {
      sheet.row(i).forEach((cell) {
        String krWord = cell!.value.toString();
        listKrWords.add(krWord);
      });
    }

    final randomKrWord = listKrWords[Random().nextInt(listKrWords.length)];
    return randomKrWord;
  }

  void wordSpeak(text) {
    TextToSpeech tts = TextToSpeech();
    tts.setVolume(1.0);
    tts.setRate(1.0);
    tts.setPitch(1.0);
    tts.setLanguage('ko-KR');
    tts.speak(text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(!ref.watch(getKrWordState)) {
      getRandomKrWord().then((word) {
        getTranslation_papago(ref, word).then((wordVi) {
          ref.watch(k_word.notifier).state = word.trim();
          ref.watch(k_word_to_vi.notifier).state = wordVi.trim();
          ref.watch(getKrWordState.notifier).state = true;
        });
      });
    }

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: MyTheme.kAccentColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12)
            ),
          ),
          child: const Center(
            child: AutoSizeText(
              'K-Words',
              maxLines: 1,
              minFontSize: 15,
              maxFontSize: 22,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // KR
                    AutoSizeText(
                      ref.watch(k_word),
                      maxLines: 1,
                      softWrap: true,
                      minFontSize: 22,
                      maxFontSize: 28,
                    ),
                    // VI
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: AutoSizeText(
                        ref.watch(k_word_to_vi),
                        maxLines: 1,
                        softWrap: true,
                        minFontSize: 22,
                        maxFontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up_rounded,
                        ),
                        onPressed: () {
                          if(ref.watch(k_word).isNotEmpty) {
                            wordSpeak(ref.watch(k_word));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                        ),
                        onPressed: () {
                          if(adCountRefresh > 0 && adCountRefresh % 5 == 0) {
                            Admob().adLoadInterstitial();
                          }
                          adCountRefresh += 1;

                          getRandomKrWord().then((word) {
                            getTranslation_papago(ref, word).then((wordVi) {
                              ref.watch(k_word.notifier).state = word.trim();
                              ref.watch(k_word_to_vi.notifier).state = wordVi.trim();
                              ref.watch(getKrWordState.notifier).state = true;
                            });
                          });
                        },
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}