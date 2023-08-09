// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/apis/papago/httpParse.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Translation extends HookConsumerWidget {
  Translation({super.key});

  final TextEditingController textEditingController = TextEditingController();

  InputDecoration textInputDecoration = const InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    isDense: true,
  );

  void wordSpeak(text) {
    FlutterTts tts = FlutterTts();
    tts.setVolume(1.0);
    tts.setSpeechRate(1.0);
    tts.setPitch(1.0);
    tts.setLanguage('ko');
    tts.speak(text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textEditingController_input = TextEditingController(
      text: ref.watch(inputText)
    );
    final TextEditingController textEditingController_output = TextEditingController(
      text: ref.watch(translatedText)
    );

    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;

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
              'Translator',
              maxLines: 1,
              minFontSize: 15,
              maxFontSize: 22,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  ref.watch(isInsertingTranslation.notifier).state = false;
                  textEditingController.clear();
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(),  // 버그인지.. 없으면 GestureDetector 작동 안함..
                  child: Column(
                    children: [
                      TextField(
                        controller: textEditingController_input,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        showCursor: false,
                        minLines: 1,
                        maxLines: 4,
                        readOnly: true,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        style: TextStyle(
                          fontSize: unitHeightValue * 1.5,
                          fontWeight: FontWeight.w300,
                          color: MyTheme.kAccentColorVariant.withOpacity(0.8),
                        ),
                        decoration: textInputDecoration,
                      ),
                      Expanded(
                        child: TextField(
                          controller: textEditingController_output,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.multiline,
                          showCursor: false,
                          minLines: 1,
                          maxLines: 10,
                          readOnly: true,
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          style: TextStyle(
                            fontSize: unitHeightValue * 2.5,
                          ),
                          decoration: textInputDecoration,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ref.watch(translatedText).isNotEmpty ? Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.volume_up_rounded,
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                  onPressed: () {
                    wordSpeak(ref.watch(translatedText));
                  },
                ),
              ) : const SizedBox.shrink(),
            ],
          ),
        ),
        Divider(
          height: 3,
          thickness: 3,
          color: MyTheme.kPrimaryColor,
        ),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          child: TextField(
            controller: textEditingController,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 20,
            style: const TextStyle(
              fontSize: 18,
            ),
            onChanged: (text) {
              if(text.isEmpty) {
                ref.watch(inputText.notifier).state = '';
                ref.watch(isInsertingTranslation.notifier).state = false;
                ref.watch(translatedText.notifier).state = '';
              } else {
                ref.watch(inputText.notifier).state = text.trim();
                ref.watch(isInsertingTranslation.notifier).state = true;
                getTranslation_papago(ref, text).then((value) {
                  ref.watch(translatedText.notifier).state = value;
                });
              }
            },
            onTap: () {
              if(ref.watch(adCountTranslator) > 0 && ref.watch(adCountTranslator) % 5 == 0) {
                Admob().adLoadInterstitial();
              }
              ref.watch(adCountTranslator.notifier).state += 1;
            },
            decoration: InputDecoration(
              hintText: "Enter the contents to translate. '◡'",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: ref.watch(isInsertingTranslation) ? IconButton(
                onPressed: () {
                  ref.watch(isInsertingTranslation.notifier).state = false;
                  ref.watch(translatedText.notifier).state = '';
                  textEditingController.clear();
                },
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                icon: Icon(
                  Icons.clear_outlined,
                  color: MyTheme.kAccentColor,
                  size: 20,
                ),
              ) : const SizedBox(
                width: 0,
                height: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// build 밖에 textEditingController & focusNode 설정
// ref: https://github.com/flutter/flutter/issues/33534
//
// onEditingComplete: () {
//   FocusScope.of(context).requestFocus(noteNode);
// },




//// 키보드 onTap -> Voca() 잠시 없애기.
////  => 키보드 isOpening? 체크 필요.
//
//// GPT -> iOS 작동 체크

// See More(...) 만들기
// 초기 로딩 화면 만들기
// 앱 아이콘 만듫기
// AOS, iOS 개발자 등록
// 앱 등록 알아보기
// 깃헙 커밋 & 푸시 / readme 작성