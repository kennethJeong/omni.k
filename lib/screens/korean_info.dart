// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/screens/krInfo/translation.dart';
import 'package:omni_k/screens/krInfo/voca.dart';

class KoreanInfo extends HookConsumerWidget {
  const KoreanInfo({super.key, required BuildContext context});

  final double viewHeight_voca = 150;

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
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              KeyboardVisibilityBuilder(
                builder: (_, isKeyboardVisible) {
                  // build layout for visible keyboard
                  if (isKeyboardVisible) {
                    return const SizedBox.shrink();
                  }
                  // build layout for invisible keyboard
                  else {
                    return Column(
                      children: [
                        Container(
                          height: viewHeight_voca,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.deepPurple.shade100,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Voca(),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    );
                  }
                }
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.deepPurple.shade100,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Translation(),
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