// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:omni_k/models/state_notifier.dart';
import 'package:omni_k/models/state_provider.dart';

class Question extends HookConsumerWidget {
  Question({super.key});

  final TextEditingController _textController = TextEditingController();

  var adCountGPT = 0;

  // if(ref.watch(adCountTranslator) > 0 && ref.watch(adCountTranslator) % 5 == 0) {
  // Admob().adLoadInterstitial();
  // }
  // ref.watch(adCountTranslator.notifier).state += 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 30,
            controller: _textController,
            onChanged: (text) {
              if(text.isNotEmpty) {
                ref.watch(isInsertingQuestion.notifier).state = true;
              } else {
                ref.watch(isInsertingQuestion.notifier).state = false;
              }
            },
            decoration: InputDecoration(
              hintText: "Ask me about Korea. '◡'",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: const EdgeInsets.all(10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: ref.watch(isInsertingQuestion) ? IconButton(
                onPressed: _textController.clear,
                alignment: Alignment.centerRight,
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
        SizedBox(
          width: 50,
          // 플랫폼 종류에 따라 적당한 버튼 추가
          child: IconButton(
            onPressed: () {
              if(adCountGPT > 0 && adCountGPT % 3 == 0) {
                Admob().adLoadInterstitial();
              }
              adCountGPT += 1;

              if(ref.watch(isInsertingQuestion)) {
                _doQuestion(context, ref, _textController.text);
              }
            },
            icon: Icon(
              FontAwesomeIcons.solidPaperPlane,
              color: MyTheme.kAccentColor,
            ),
          ),
        ),
      ],
    );
  }

  void _doQuestion(BuildContext context, WidgetRef ref, String text) {
    ref.watch(prompt.notifier).state = text;

    _textController.clear();

    ref.watch(isInsertingQuestion.notifier).state = false;

    ref.watch(isAsked.notifier).state = true;

    ref.watch(listViewProviderGPT.notifier).addItem(
      ChatBubble(
        clipper: ChatBubbleClipper6(type: BubbleType.sendBubble),
        alignment: Alignment.centerRight,
        backGroundColor: MyTheme.kAccentColor,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .7,
          ),
          child: Text(
            text.trim(),
            maxLines: null,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          )
        ),
      ),
    );

    ref.watch(listViewProviderGPT.notifier).addItem(
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: CircularProgressIndicator(
            color: Colors.deepPurple.shade100,
          )
        )
      ),
    );
  }
}