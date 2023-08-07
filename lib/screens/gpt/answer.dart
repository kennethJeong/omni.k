import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:omni_k/apis/chatGPT/httpParse.dart';
import 'package:omni_k/models/classes.dart';
import 'package:omni_k/models/state_notifier.dart';
import 'package:omni_k/models/state_provider.dart';

class Answer extends HookConsumerWidget {
  Answer({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(prompt).trim();

    WidgetsBinding.instance.addPostFrameCallback((_) => {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 500),
        ),
      }
    });

    if(question.isNotEmpty && ref.watch(isAsked)) {
      completionChat(ref, question).then((value) {
        ref.watch(listViewProviderGPT.notifier).removeLastOne();

        final answer = value.trim();

        ref.watch(listViewProviderGPT.notifier).addItem(
          ChatBubble(
            clipper: ChatBubbleClipper6(type: BubbleType.receiverBubble),
            alignment: Alignment.centerLeft,
            backGroundColor: const Color(0xffE7E7ED),
            margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .7
              ),
              child: Text(
                answer.trim(),
                maxLines: null,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              )
            ),
          ),
        );

        final messageSet = Messages(question: question, answer: answer);
        ref.watch(chatProvider.notifier).addMessages(messageSet);

        ref.watch(isAsked.notifier).state = false;
        ref.watch(prompt.notifier).state = '';
      });
    }

    return GestureDetector(
      onTap: () => !ref.watch(isAsked) ? FocusScope.of(context).unfocus() : null,
      child: ListView.builder(
        reverse: true,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: ref.watch(listViewProviderGPT).length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ref.watch(listViewProviderGPT)[index]
            ],
          );
        },
      ),
    );
  }
}