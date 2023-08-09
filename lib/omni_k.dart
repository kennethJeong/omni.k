import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/bottom_iconData.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/screens/news_room.dart';
import 'package:omni_k/screens/psycho_test.dart';
import 'package:omni_k/screens/korean_info.dart';
import 'package:omni_k/screens/omni_gpt.dart';
import 'package:omni_k/screens/see_more.dart';
import 'package:omni_k/widgets/bottom_bar.dart';

class OmniK extends HookConsumerWidget {
  const OmniK({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("<<Processing>> OmniK");

    final pages = [
      NewsRoom(context: context),
      PsychoTest(context: context),
      KoreanInfo(context: context),
      OmniGPT(context: context),
    ];

    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
            toolbarHeight: ref.watch(heightAppBar),
            forceMaterialTransparency: true,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
            title: Text(
              'OMNI.K',
              style: TextStyle(
                fontSize: 25,
                color: Colors.deepPurple[200],
              ),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(
                    BottomIconData.iconData_seeMore
                  ),
                  onPressed: () => Scaffold.of(context).openEndDrawer()
                ),
              ),
            ]
        ),
        bottomNavigationBar: BottomBar(),
        drawerScrimColor: Colors.white.withOpacity(0),
        endDrawer: SeeMore(),
        body: SafeArea(
          bottom: false,
          child: pages[ref.watch(bottomNavIndex)]
        ),
      ),
    );
  }
}




