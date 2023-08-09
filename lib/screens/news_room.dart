// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:omni_k/admob.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/models/classes.dart';
import 'package:omni_k/models/state_notifier.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:omni_k/utils/errorResponse.dart';
import 'package:omni_k/widgets/news_room.dart';
// Packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Api
import 'package:omni_k/apis/netflix/httpParse.dart';
import 'package:omni_k/apis/tiktok/httpParse.dart';
import 'package:omni_k/apis/youtube/httpParse.dart';
import 'package:omni_k/apis/instagram/httpParse.dart';
import 'package:omni_k/apis/kpops/httpParse.dart';
import 'package:omni_k/apis/musinsa/httpParse.dart';

class NewsRoom extends HookConsumerWidget {
  NewsRoom({super.key, required BuildContext context});

  final ScrollController scrollController = ScrollController();

  bool isInit = false;
  List<Widget> tempList = [];
  int loadingTimer = 2500;
  Map<String, int>? contentsShowLimit;

  var adCountBottomEdge = 0;

  final Map<String, bool> contentsCheckList = {
    'facebook': false,
    'tiktok': false,
    'instagram': false,
    'netflix': false,
    'youtube': false,
    'musinsa': false,
    'kpops': false,
  };

  //
  // Go to Top in ListView
  void goToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  //
  // Pull To Refresh in Listview
  Future<void> pullRefresh(BuildContext context, WidgetRef ref) async {
    contentsCheckList.updateAll((key, value) => value == false);
    ref.watch(listViewProviderNews.notifier).removeAll();
    api_init(context, ref);
  }

  //
  // Add new contents when the scroll touches the floor of the ListView
  Future<void> addContentsWithScrolling(BuildContext context, WidgetRef ref) async {
    contentsCheckList.updateAll((key, value) => value == false);

    if(adCountBottomEdge > 0 && adCountBottomEdge % 5 == 0) {
      Admob().adLoadInterstitial();
    }
    adCountBottomEdge += 1;

    api_init(context, ref);
  }

  //
  // State of CircularProgressIndicator
  Future<Timer> showLoadingIndicator(WidgetRef ref) async {
    Future.delayed(Duration.zero, () {
      ref.watch(isLoading_NewsRoom.notifier).state = true;
    });
    return Timer(Duration(milliseconds: loadingTimer), () {
      ref.watch(isLoading_NewsRoom.notifier).state = false;
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Netflix ///////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_netflix(BuildContext context, WidgetRef ref) {
    String newsSort = 'netflix';
    List<String> list_genre_netflix = ['drama', 'movie'];
    String genre_netflix = list_genre_netflix[Random().nextInt(list_genre_netflix.length)];

    if(contentsCheckList[newsSort] == false) {
      contentsCheckList[newsSort] = true;
      get_contents_netflix(genre_netflix).then((dataNetflix) {
        if(dataNetflix.isNotEmpty) {
          List<int> listRandomNum = List.generate(dataNetflix.length, (i) => i);
          listRandomNum.shuffle();    // 중복 방지

          for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
            final randomNum = listRandomNum[i];
            Map<String, String> randomValue = dataNetflix[randomNum];


            final newsRoomData = NewsRoomData(
              newsSort,
              randomValue['title']!,
              randomValue['img']!,
              randomValue['link']!,
            );

            tempList.add(widgetNews(context, newsRoomData));
          }
        }
      });
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Tiktok ////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_tiktok(BuildContext context, WidgetRef ref) {
    String newsSort = 'tiktok';
    List<String> keywordsTiktok = [
      "kpop",
      "케이팝"
      "korea",
      "한국",
      "challenge",
      "챌린지",
      "girlgroup",
      "걸그룹",
      "idol",
      "아이돌",
    ];
    String randomKeywordTiktok = keywordsTiktok[Random().nextInt(keywordsTiktok.length)];

    if(contentsCheckList[newsSort] == false) {
      contentsCheckList[newsSort] = true;

      // listItemsProviderTiktok 가 비어있으면 -> api call 'O'
      if(ref.watch(listItemsProviderTiktok).isEmpty) {
        get_contents_tiktok(randomKeywordTiktok).then((dataTiktok){
          if(dataTiktok.isNotEmpty) {
            // n개 widget -> listItemsProviderTiktok 에 담기
            for(var i=0; i<dataTiktok.length; i++) {
              Map<String, String> eachDataTiktok = dataTiktok[i];
              final newsRoomData = NewsRoomData(
                newsSort,
                eachDataTiktok['title']!,
                eachDataTiktok['img']!,
                eachDataTiktok['link']!,
              );

              ref.watch(listItemsProviderTiktok.notifier).addItem(
                widgetNews(context, newsRoomData)
              );
            }

            for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
              // listItemsProviderTiktok 에서 랜덤으로 Widget 추출해서
              Widget randomWidget = (ref.watch(listItemsProviderTiktok).toList()..shuffle()).first;

              // ListView 에 추가.
              tempList.add(randomWidget);

              // 추가된 Widget 은 listItemsProviderTiktok 에서 제거.
              ref.watch(listItemsProviderTiktok.notifier).removeWidget(randomWidget);

              // print("남은 item 개수: ${ref.watch(listItemsProviderTiktok).length}");
            }
          }
        });
      }
      // listItemsProviderTiktok 에 widget 이 남아있으면 -> api call 'X' / listItemsProviderTiktok 에서 가져오기
      else {
        for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
          // listItemsProviderTiktok 에서 랜덤으로 Widget 추출해서
          Widget randomWidget = (ref.watch(listItemsProviderTiktok).toList()..shuffle()).first;

          // ListView 에 추가.
          tempList.add(randomWidget);

          // 추가된 Widget 은 listItemsProviderTiktok 에서 제거.
          ref.watch(listItemsProviderTiktok.notifier).removeWidget(randomWidget);

          // print("남은 item 개수: ${ref.watch(listItemsProviderTiktok).length}");
        }
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////// Youtube //////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_youtube(BuildContext context, WidgetRef ref) {
    String newsSort = 'youtube';
    List<String> keywordsYoutube = [
      "kpop",
      "kpop mv",
      "kpop girl group",
      "kpop in public",
      "kpop challenge dance",
    ];
    String randomKeywordYoutube = keywordsYoutube[Random().nextInt(keywordsYoutube.length)];
    // List<String> relatedToVideoIdYoutube = [
    //   "di6gc9zarZc",    // 직캠
    //   "7HDeem-JaSY",    // 뮤비
    //   "mI2y2tEBPbQ",    // 챌린지
    // ];
    // String RandomRelatedToVideoIdYoutube = relatedToVideoIdYoutube[Random().nextInt(relatedToVideoIdYoutube.length)];

    if(contentsCheckList[newsSort] == false) {
      contentsCheckList[newsSort] = true;

      // listItemsProviderYoutube 가 비어있으면 -> api call 'O'
      if(ref.watch(listItemsProviderYoutube).isEmpty) {
        get_contents_youtube(randomKeywordYoutube, '').then((dataYoutube){
          if(dataYoutube.isNotEmpty) {
            // n개 widget -> listItemsProviderYoutube 에 담기
            for(var i=0; i<dataYoutube.length; i++) {
              Map<String, String> eachDataYoutube = dataYoutube[i];
              final newsRoomData = NewsRoomData(
                newsSort,
                eachDataYoutube['title']!,
                eachDataYoutube['img']!,
                eachDataYoutube['link']!,
              );

              ref.watch(listItemsProviderYoutube.notifier).addItem(
                widgetNews(context, newsRoomData)
              );
            }

            for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
              // listItemsProviderTiktok 에서 랜덤으로 Widget 추출해서
              Widget randomWidget = (ref.watch(listItemsProviderYoutube).toList()..shuffle()).first;

              // ListView 에 추가.
              tempList.add(randomWidget);

              // 추가된 Widget 은 listItemsProviderYoutube 에서 제거.
              ref.watch(listItemsProviderYoutube.notifier).removeWidget(randomWidget);

              // print("남은 item 개수: ${ref.watch(listItemsProviderYoutube).length}");
            }
          }
        });
      }
      // listItemsProviderYoutube 에 widget 이 남아있으면 -> api call 'X' / listItemsProviderYoutube 에서 가져오기
      else {
        for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
          // listItemsProviderYoutube 에서 랜덤으로 Widget 추출해서
          Widget randomWidget = (ref.watch(listItemsProviderYoutube).toList()..shuffle()).first;

          // ListView 에 추가.
          tempList.add(randomWidget);

          // 추가된 Widget 은 listItemsProviderYoutube 에서 제거.
          ref.watch(listItemsProviderYoutube.notifier).removeWidget(randomWidget);

          // print("남은 item 개수: ${ref.watch(listItemsProviderYoutube).length}");
        }
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Instagram /////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_instagram(BuildContext context, WidgetRef ref) {
    String newsSort = 'instagram';
    if(contentsCheckList[newsSort] == false) {
      contentsCheckList[newsSort] = true;
      get_contents_instagram().then((dataInstagram) {
        if(dataInstagram.isNotEmpty) {
          dataInstagram['sort'] = newsSort;
          NewsRoomData_Instagram newsRoomData_Instagram = NewsRoomData_Instagram.fromJson(dataInstagram);

          tempList.add(widgetNews_instagram(context, newsRoomData_Instagram));
        }
      });
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Musinsa ///////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_musinsa(BuildContext context, WidgetRef ref) {
    String newsSort = 'musinsa';
    if(contentsCheckList[newsSort] == false) {
      contentsCheckList[newsSort] = true;
      get_contents_musinsa().then((dataMusinsa) {
        if(dataMusinsa.isNotEmpty) {
            List<int> listRandomNum = List.generate(dataMusinsa.length, (i) => i);
            listRandomNum.shuffle();
            List<Map<String, String>> listRandom = [];
            for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
              Map<String, String> randomDataMusinsa = dataMusinsa[i];
              listRandom.add(randomDataMusinsa);
            }

            tempList.add(widgetNews_musinsa(context, listRandom));
          }
        }
      );
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Facebook //////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_kpops(BuildContext context, WidgetRef ref) {
    String newsSort = 'kpops';

    // listItemsProviderKpops 가 비어있으면 -> api call 'O'
    if(ref.watch(listItemsProviderKpops).isEmpty) {
      get_contents_kpops().then((dataKpops){
        if(dataKpops.isNotEmpty) {
          // n개 widget -> listItemsProviderKpops 에 담기
          for(var i=0; i<dataKpops.length; i++) {
            Map<String, String> eachDataKpops = dataKpops[i];
            ref.watch(listItemsProviderKpops.notifier).addItem(
              widgetNews_kpops(context, eachDataKpops)
            );
          }

          for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
            // listItemsProviderKpops 에서 랜덤으로 Widget 추출해서
            Widget randomWidget = (ref.watch(listItemsProviderKpops).toList()..shuffle()).first;

            // ListView 에 추가.
            tempList.add(randomWidget);

            // 추가된 Widget 은 listItemsProviderKpops 에서 제거.
            ref.watch(listItemsProviderKpops.notifier).removeWidget(randomWidget);

            // print("남은 item 개수: ${ref.watch(listItemsProviderKpops).length}");
          }
        }
      });
    }
    // listItemsProviderKpops 에 widget 이 남아있으면 -> api call 'X' / listItemsProviderKpops 에서 가져오기
    else {
      for(var i=0; i<contentsShowLimit![newsSort]!; i++) {
        // listItemsProviderKpops 에서 랜덤으로 Widget 추출해서
        Widget randomWidget = (ref.watch(listItemsProviderKpops).toList()..shuffle()).first;

        // ListView 에 추가.
        tempList.add(randomWidget);

        // 추가된 Widget 은 listItemsProviderKpops 에서 제거.
        ref.watch(listItemsProviderKpops.notifier).removeWidget(randomWidget);

        // print("남은 item 개수: ${ref.watch(listItemsProviderKpops).length}");
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////// Facebook //////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  void api_facebook(BuildContext context, WidgetRef ref) {

  }
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  void runApi(void function) {
    try {
      function;
    } catch(e) {
      ErrorResponse().errorReport(e.toString());
    }
  }

  //
  // Initiate all api
  void api_init(BuildContext context, WidgetRef ref) async {
    showLoadingIndicator(ref).then((value) {
      ////
      runApi(api_netflix(context, ref));
      runApi(api_tiktok(context, ref));
      runApi(api_instagram(context, ref));
      runApi(api_musinsa(context, ref));
      runApi(api_kpops(context, ref));
      // runApi(api_youtube(context, ref));

      // api_facebook(context, ref);
      ////
    });

    Timer(Duration(milliseconds: loadingTimer), () {
      // tempList.shuffle();

      //
      // add adBanner
      tempList.add(
        Admob().widgetAdBanner(context, 70)
      );

      for(var i=0; i<tempList.length; i++) {
        ref.watch(listViewProviderNews.notifier).addItem(
          tempList[i]
        );
      }
      tempList.clear();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listViewProvider_News = ref.watch(listViewProviderNews);

    // Get contents show limit from local directory(txt file)
    if(ref.watch(contentsLimitNewsRoom).isNotEmpty) {
      contentsShowLimit = ref.watch(contentsLimitNewsRoom);
    }

    //////////// Initiate Build ////////////
    if(!isInit) {
      isInit = true;

      scrollController.addListener(() {
        if(scrollController.position.atEdge) {
          // 스크롤이 ListView 의 Top Edge 에 도달했을 때 -> contents 추가.
          if(scrollController.position.pixels == 0) {

          }
          // 스크롤이 ListView 의 Bottom Edge 에 도달했을 때 -> contents 추가.
          else {
            addContentsWithScrolling(context, ref);
          }
        }

        // 스크롤 움직임 감지 -> GoToTop Floating 버튼 visible 값 변경.
        if(scrollController.offset == scrollController.position.minScrollExtent) {
          ref.watch(isScrolling_NewsRoom.notifier).state = false;
        } else {
          ref.watch(isScrolling_NewsRoom.notifier).state = true;
        }
      });
    }

    if(!ref.read(isInit_NewsRoom)) {
      Future.delayed(Duration.zero, () {
        ref.read(isInit_NewsRoom.notifier).state = true;
      });

      api_init(context, ref);
    }
    ////////////////////////////////////////

    return Stack(
      children: [
        RefreshIndicator(
          color: MyTheme.kPrimaryColorVariant,
          onRefresh: () async => await pullRefresh(context, ref),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: listViewProvider_News.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  listViewProvider_News[index],
                ],
              );
            },
          ),
        ),
        ref.watch(isScrolling_NewsRoom) ? Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: kBottomNavigationBarHeight + 20),
            child: FloatingActionButton(
              elevation: 7,
              backgroundColor: MyTheme.kPrimaryColor,
              child: const Icon(
                Icons.keyboard_double_arrow_up_rounded,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () {
                goToTop(scrollController);
              },
            ),
          ),
        ) : const SizedBox.shrink(),
        ref.watch(isLoading_NewsRoom) ? Container(
          color: Colors.white10.withOpacity(0.1),
          child: Center(
            child: CircularProgressIndicator(
              color: MyTheme.kPrimaryColorVariant,
            ),
          ),
        ) : const SizedBox.shrink(),
      ]
    );
  }
}
