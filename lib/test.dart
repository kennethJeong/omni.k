import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/apis/kpops/httpParse.dart';

class Test extends HookConsumerWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("<<<<<<<<<<<<<<<<< TEST >>>>>>>>>>>>>>>>>>>");

    get_contents_kpops().then((value) {
      debugPrint(value.toString(), wrapWidth: 1024);
    });


    return MaterialApp(
      home: Container(),
      debugShowCheckedModeBanner: false,
    );
  }
}