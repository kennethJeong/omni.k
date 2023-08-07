// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// init.dart
final contentsLimitNewsRoom = StateProvider<Map<String, int>>((ref) => {});
final contentsValue_tiktok = StateProvider<int>((ref) => 2);
final contentsValue_netflix = StateProvider<int>((ref) => 2);
final contentsValue_youtube = StateProvider<int>((ref) => 1);
final contentsValue_musinsa = StateProvider<int>((ref) => 5);
final contentsValue_kpops = StateProvider<int>((ref) => 2);

final stateDarkmode = StateProvider<int>((ref) => 0);
final switchDarkmode = StateProvider<bool>((ref) => false);

// splash_screen.dart
final isInit_splash = StateProvider<bool>((ref) => true);

// news_room.dart
final isInit_NewsRoom = StateProvider<bool>((ref) => false);
final isLoading_NewsRoom = StateProvider<bool>((ref) => false);
final isScrolling_NewsRoom = StateProvider<bool>((ref) => false);
final adNativeProvider = StateProvider<Widget>((ref) => const SizedBox.shrink());

// pTest/pTest.dart
final check_scroll_webview = StateProvider.autoDispose<bool>((ref) => false);
final check_swipe_webview = StateProvider.autoDispose<bool>((ref) => false);

// krInfo/translation.drat
final translatedText = StateProvider.autoDispose<String>((ref) => '');
final inputText = StateProvider.autoDispose<String>((ref) => '');
final isInsertingTranslation = StateProvider.autoDispose<bool>((ref) => false);
final adCountTranslator = StateProvider.autoDispose<int>((ref) => 0);

// krInfo/voca.dart
final k_word = StateProvider.autoDispose<String>((ref) => '');
final k_word_to_vi = StateProvider.autoDispose<String>((ref) => '');
final getKrWordState = StateProvider.autoDispose<bool>((ref) => false);

// gpt/question.dart
final prompt = StateProvider.autoDispose<String>((ref) => '');
final isInsertingQuestion = StateProvider.autoDispose<bool>((ref) => false);
final isAsked = StateProvider.autoDispose<bool>((ref) => false);

// bottom_bar.dart
final heightBottomBar = StateProvider<double>((ref) => kBottomNavigationBarHeight);
final bottomNavIndex = StateProvider<int>((ref) => 0);

// main.dart
final heightAppBar = StateProvider<double>((ref) => kToolbarHeight);

// admob.dart
final isAdBannerLoad = StateProvider<bool>((ref) => false);