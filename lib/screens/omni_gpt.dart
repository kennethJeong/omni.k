// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/screens/gpt/answer.dart';
import 'package:omni_k/screens/gpt/question.dart';

class OmniGPT extends HookConsumerWidget {
  const OmniGPT({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final viewHeight = constraints.maxHeight * 0.9;
        return Container(
          constraints: BoxConstraints(
            minHeight: viewHeight,
            maxHeight: constraints.maxHeight
              - MediaQuery.of(context).padding.top
              - MediaQuery.of(context).padding.bottom
              - 5
          ),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.deepPurple.shade100,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Answer(),
                )
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.deepPurple.shade100,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Question(),
                ),
              ),
              Admob().widgetAdBanner(context, 70),
            ],
          )
        );
      }
    );
  }
}