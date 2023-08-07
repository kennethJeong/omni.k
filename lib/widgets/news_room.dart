// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/models/classes.dart';
import 'package:omni_k/utils/open_link.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//
// Listview 에 들어가는 기본 위젯
Widget widgetNews(BuildContext context, NewsRoomData newsRoomData) {
  double height = MediaQuery.of(context).size.height / 3;
  double aspectRatio_youtube = 1.2;
  double aspectRatio_tiktok = 1.7;

  switch(newsRoomData.sort) {
    case 'netflix': height = height; break;
    case 'youtube': height = height * aspectRatio_youtube; break;
    case 'tiktok': height = MediaQuery.of(context).size.height / aspectRatio_tiktok; break;
  }

  return Column(
    children: [
      Stack(
        children: [
          SizedBox(
            height: height,
            child: InkWell(
                onTap: () {
                  openLink(newsRoomData.link);
                }, // Handle your callback.
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: Image.network(
                          newsRoomData.img,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          newsRoomData.title,
                          minFontSize: 14,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          //
          // Logo Image of each content
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Image(
              image: AssetImage(
                  "assets/images/contents/${newsRoomData.sort}.png"
              ),
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget widgetNews_instagram(BuildContext context, NewsRoomData_Instagram newsRoomData_Instagram) {
  double height = MediaQuery.of(context).size.height / 8;

  return Column(
    children: [
      Stack(
        children: [
          SizedBox(
            height: height,
            child: InkWell(
              onTap: () {
                openLink(newsRoomData_Instagram.link);
              }, // Handle your callback.
              child: Row(
                children: [
                  SizedBox(
                    width: height,
                    height: height,
                    child: Image.network(newsRoomData_Instagram.img),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: AutoSizeText(
                            newsRoomData_Instagram.name,
                            minFontSize: 18,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 26,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: AutoSizeText(
                            '@${newsRoomData_Instagram.instagram_id}',
                            minFontSize: 10,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${newsRoomData_Instagram.followers} Followers',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //
          // Logo Image of each content
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Image(
              image: AssetImage(
                "assets/images/contents/${newsRoomData_Instagram.sort}.png"
              ),
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget widgetNews_musinsa(BuildContext context, List<Map<String, String>> dataMusinsa) {
  double height = MediaQuery.of(context).size.height / 2;

  final PageController pageController = PageController(
    viewportFraction: 0.7,
    initialPage: 9991,
    keepPage: true,
  );

  return Column(
    children: [
      Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: height,
                  child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final link = dataMusinsa[index % dataMusinsa.length]['link'];
                      final img = dataMusinsa[index % dataMusinsa.length]['img'];

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: InkWell(
                          onTap: () {
                            openLink(link!);
                          }, // Handle your callback.
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              img!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  controller: pageController,
                  count: dataMusinsa.length,
                  effect: ScrollingDotsEffect(
                    activeStrokeWidth: 2.6,
                    activeDotScale: 1.3,
                    maxVisibleDots: dataMusinsa.length,
                    radius: 8,
                    spacing: 10,
                    dotHeight: 5,
                    dotWidth: 8,
                    dotColor: MyTheme.kPrimaryColorVariant,
                    activeDotColor: MyTheme.kAccentColorVariant,
                  ),
                ),
              ],
            ),
            //
            // Floating Logo Image
            Container(
              alignment: Alignment.topLeft,
              width: 70,
              height: 20,
              color: Colors.black,
              margin: const EdgeInsets.all(5),
              child: const Center(
                child: Image(
                  image: AssetImage(
                    "assets/images/contents/musinsa.png"
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ]
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget widgetNews_kpops(BuildContext context, Map<String, String> dataKpops) {
  double height = MediaQuery.of(context).size.height / 8;

  return Column(
    children: [
      Stack(
        children: [
          SizedBox(
            height: height,
            child: InkWell(
              onTap: () {
                openLink(dataKpops['link']!);
              }, // Handle your callback.
              child: Row(
                children: [
                  SizedBox(
                    width: height,
                    height: height,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        padding: const EdgeInsets.all(3), // Border width
                        decoration: BoxDecoration(
                          color: MyTheme.kPrimaryColor,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: Image.network(
                              dataKpops['image']!,
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          dataKpops['title']!,
                          maxLines: 1,
                          minFontSize: 18,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: AutoSizeText(
                            dataKpops['artist']!,
                            maxLines: 1,
                            minFontSize: 15,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    ],
  );
}