import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_k/config.dart';
import 'package:omni_k/omni_k.dart';
import 'package:omni_k/models/state_provider.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("<<Processing>> Splash Screen");

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    double bottomHeight = 50.0;
    int timerCount = 3000;

    const iconFile = 'Icon-1024.png';

    //
    // Move to main screen after $timerCount
    if(ref.watch(isInit_splash)) {
      Future.delayed(Duration.zero, () {
        ref.watch(isInit_splash.notifier).state = false;
      });

      Future.delayed(Duration(milliseconds: timerCount), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OmniK(),
          ),
        );
      });
    }

    //
    // Read news room initial setting (-> contentsShowLimit)
    Future.delayed(const Duration(milliseconds: 1000), () {
      readConfig('newsroom').then((val) {
        ref.watch(contentsLimitNewsRoom.notifier).state = val;
        val.forEach((k, v) {
          if(k == 'tiktok') {
            ref.watch(contentsValue_tiktok.notifier).state = v;
          }
          else if(k == 'netflix') {
            ref.watch(contentsValue_netflix.notifier).state = v;
          }
          else if(k == 'youtube') {
            ref.watch(contentsValue_youtube.notifier).state = v;
          }
          else if(k == 'musinsa') {
            ref.watch(contentsValue_musinsa.notifier).state = v;
          }
          else if(k == 'kpops') {
            ref.watch(contentsValue_kpops.notifier).state = v;
          }
        });
        print("<<Processing>> readConfig => newsroom");
      });
    });

    //
    // Read dark mode initial setting (-> switchDarkmode)
    Future.delayed(const Duration(milliseconds: 1000), () {
      readConfig('darkmode').then((val) {
        ref.watch(stateDarkmode.notifier).state = val;

        final stateDarkMode = ref.watch(stateDarkmode);
        if(stateDarkMode == 0) {   // Bright Mode
          ref.read(switchDarkmode.notifier).state = false;
        }
        else {                      // Dark Mode
          ref.read(switchDarkmode.notifier).state = true;
        }
        print("<<Processing>> readConfig => darkmode");
      });
    });


    return Scaffold(
      body: Container(
        color: Colors.black,
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight - bottomHeight,
              child: Padding(
                padding: EdgeInsets.only(top: bottomHeight),
                child: const Center(
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/icons/logo/$iconFile"
                    ),
                  ),
                ),
              )
            ),
            Container(
              height: bottomHeight,
              alignment: Alignment.topCenter,
              child: const Text(
                "© Copyright 2023, Omni.K",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}