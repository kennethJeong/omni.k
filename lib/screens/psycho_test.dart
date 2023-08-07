import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/screens/pTest/pTest.dart';

class PsychoTest extends HookConsumerWidget {
  const PsychoTest({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final viewHeight = constraints.maxHeight * 0.7;
        double adHeight = 70;
        return Column(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: viewHeight,
                maxHeight: constraints.maxHeight
                  - MediaQuery.of(context).padding.top
                  - MediaQuery.of(context).padding.bottom
                  - adHeight
              ),
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.deepPurple.shade100,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: PTest(heightPTest: viewHeight),
            ),
            Admob().widgetAdBanner(context, adHeight),
          ],
        );
      },
    );
  }
}