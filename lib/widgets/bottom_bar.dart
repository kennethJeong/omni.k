import 'dart:io';
import 'package:flutter/material.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/bottom_iconData.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class BottomBar extends HookConsumerWidget {
  BottomBar({super.key});

  final iconList = <IconData>[
    BottomIconData.iconData_newsRoom,
    BottomIconData.iconData_test,
    BottomIconData.iconData_voca,
    BottomIconData.iconData_chat,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBottomNavigationBar(
      elevation: 0,
      height: ref.watch(heightBottomBar),
      icons: iconList,
      iconSize: 25,
      backgroundColor: MyTheme.kPrimaryColor.withOpacity(0.8),
      activeIndex: ref.watch(bottomNavIndex),
      activeColor: MyTheme.kAccentColor,
      splashColor: MyTheme.kPrimaryColor,
      inactiveColor: Colors.white,
      // notchAndCornersAnimation: animation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      safeAreaValues: const SafeAreaValues(
        top: false,
        bottom: false,
      ),
      // gapLocation: ref.read(bottomNavIndex) == 0 ? GapLocation.center : GapLocation.none,
      gapLocation: GapLocation.none,
      leftCornerRadius: Platform.isAndroid ? 32 : 0,
      rightCornerRadius: Platform.isAndroid ? 32 : 0,
      onTap: (index) {
        if(!ref.watch(isLoading_NewsRoom)) {
          ref.watch(bottomNavIndex.notifier).state = index;
        } else {
          null;
        }
      },
    );
  }
}