// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mailer/smtp_server.dart';
import 'package:omni_k/app_theme.dart';
import 'package:omni_k/config.dart';
import 'package:omni_k/models/state_provider.dart';
import 'package:mailer/mailer.dart';
import 'package:flutter_config/flutter_config.dart';

class SeeMore extends HookConsumerWidget {
  SeeMore({super.key});

  double? viewWidth;
  double height_eachTitle = 50;
  double height_eachContents = 40;
  Map<String, int>? configMap_newsroom;
  final _formKey = GlobalKey<FormState>();

  String contactName = '';
  String contactEmail = '';
  String contactContent = '';

  Map<String, RangeValues> contentsRangeNewsRoom = {
    'tiktok': const RangeValues(1, 3),      // range 1 ~ 3
    'netflix': const RangeValues(1, 3),     // range 1 ~ 3
    'youtube': const RangeValues(1, 2),     // range 1 ~ 2
    'musinsa': const RangeValues(5, 15),     // range 5 ~ 15
    'kpops': const RangeValues(2, 5),     // range 2 ~ 5
  };

  List<Widget> listWrapperRow(BuildContext context, WidgetRef ref) {
    return [
      wrapperRow(context, ref, darkTheme(context, ref)),
      ref.watch(bottomNavIndex) == 0 ? wrapperRow(context, ref, newsRoomContentsReg(context, ref)) : const SizedBox.shrink(),
      wrapperRow(context, ref, contactUs(context, ref)),
    ];
  }

  Future<void> sendEmail(String contactName, String contactEmail, String contactContent) async {
    var body = 'DateTime: ${DateTime.now()}';
    body += '\n Name: $contactName';
    body += '\n Email: $contactEmail';
    body += '\n Content: $contactContent';

    String username = 'dev.kennyJ@gmail.com';
    String password = Platform.isAndroid ? FlutterConfig.get('gmail_pw_aos').toString() : FlutterConfig.get('gmail_pw_ios').toString();
    String bccUsername = 'eunuism@gmail.com';

    var smtpServer = gmail(username, password);
    final equivalentMessage = Message()
      ..from = Address(username, 'Omni.K')
      ..subject = '[Inquiry [Omni.K]] :: ${DateTime.now()}'
      ..recipients.add(Address(username))
      ..bccRecipients.add(Address(bccUsername))
      ..text = body;

    try {
      await send(equivalentMessage, smtpServer);
      print("A mail is sent");
    } catch (error) {
      print(error);
    }
  }

  Future alertDialogAfterEmail(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: null,
          content: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your inquiry has been received.",
                    style: TextStyle(
                      color: MyTheme.kPrimaryColorVariant,
                      fontSize: 23,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Text(
                    "Thanks you :)",
                    style: TextStyle(
                      color: MyTheme.kPrimaryColorVariant,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(MyTheme.kPrimaryColor),
                    ),
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Center(
                      child: AutoSizeText(
                        "Close",
                        maxLines: 1,
                        minFontSize: 15,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  //
  // Contact us
  Widget contactUs(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height_eachTitle,
      child: Row(
        children: [
          const Expanded(
            child: AutoSizeText(
              'Contact Us',
              maxLines: 1,
              minFontSize: 16,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                alertDialogContactUs(context);
              },
              icon: const Icon(
                Icons.email_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  // AlertDialog Function for [Contact Us]
  Future alertDialogContactUs(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyTheme.kPrimaryColorVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AutoSizeText(
                          "Contact Us",
                          maxLines: 1,
                          minFontSize: 25,
                          style: TextStyle(
                            fontSize: 30,
                            color: MyTheme.kPrimaryColorVariant,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 3,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Colors.black12,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: TextFormField(
                                    validator: (inputName) {
                                      if (inputName == null || inputName.isEmpty) {
                                        return 'Please enter your name';
                                      } else {
                                        contactName = inputName;
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Name',
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 5, bottom: 5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: TextFormField(
                                    validator: (inputEmail) {
                                      if (inputEmail == null || inputEmail.isEmpty) {
                                        return 'Please enter your E-mail';
                                      } else {
                                        contactEmail = inputEmail;
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 5, bottom: 5)
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: MyTheme.kPrimaryColorVariant,
                                        width: 1,
                                      ),
                                    ),
                                    child: TextFormField(
                                      validator: (inputContent) {
                                        if (inputContent == null || inputContent.isEmpty) {
                                          return 'Please enter your query';
                                        } else {
                                          contactContent = inputContent;
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        hintText: 'Content',
                                        contentPadding: EdgeInsets.all(10),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(MyTheme.kPrimaryColor),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  sendEmail(contactName, contactEmail, contactContent);
                                  alertDialogAfterEmail(context);
                                }
                              },
                              child: const Center(
                                child: AutoSizeText(
                                  "Send",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
  // Wrapper for each Row
  Widget wrapperRow(BuildContext context, WidgetRef ref, Widget row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyTheme.kPrimaryColorVariant.withOpacity(0.16),
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: row,
    );
  }


  //
  // Switch for Dark Mode
  Widget darkTheme(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height_eachTitle,
      child: Row(
        children: [
          const Expanded(
            child: AutoSizeText(
              'Dark Theme',
              maxLines: 1,
              minFontSize: 16,
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Switch(
              value: ref.watch(switchDarkmode),
              activeColor: MyTheme.kAccentColorVariant,
              onChanged: (value) {
                ref.watch(switchDarkmode.notifier).state = value;

                // Write the value to local file.
                int writeValue = 0;
                value ? writeValue = 1 : writeValue = 0;
                writeConfig('darkmode', writeValue.toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> listTileContents(BuildContext context, WidgetRef ref) {
    return [
      listContents(context, ref, 'tiktok'),
      listContents(context, ref, 'netflix'),
      listContents(context, ref, 'youtube'),
      listContents(context, ref, 'musinsa'),
      listContents(context, ref, 'kpops'),
    ];
  }

  //
  // Adjust the number of contents to be displayed in the newsroom.
  Widget newsRoomContentsReg(BuildContext context, WidgetRef ref) {
    Container contentsTitle() {
      return Container(
        alignment: Alignment.centerLeft,
        height: height_eachTitle,
        child: const AutoSizeText(
          'Contents',
          textAlign: TextAlign.left,
          maxLines: 1,
          minFontSize: 16,
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400
          ),
        ),
      );
    }

    Container contentsDivider() {
      return Container(
        height: 1,
        color: Colors.white.withOpacity(0.5),
      );
    }

    return Column(
      children: [
        contentsTitle(),
        contentsDivider(),
        ...
        listTileContents(context, ref)
      ],
    );
  }

  Widget listContents(BuildContext context, WidgetRef ref, String contents) {
    int contentsRangeStart = contentsRangeNewsRoom[contents]!.start.toInt();
    int contentsRangeEnd = contentsRangeNewsRoom[contents]!.end.toInt();
    List<int> listContentsRange = [for (var i=contentsRangeStart; i<=contentsRangeEnd; i++) i];

    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    StateProvider<int> dropdownValue = StateProvider<int>((ref) => 1);
    if(contents == 'tiktok') {
      dropdownValue = contentsValue_tiktok;
    }
    else if(contents == 'netflix') {
      dropdownValue = contentsValue_netflix;
    }
    else if(contents == 'youtube') {
      dropdownValue = contentsValue_youtube;
    }
    else if(contents == 'musinsa') {
      dropdownValue = contentsValue_musinsa;
    }
    else if(contents == 'kpops') {
      dropdownValue = contentsValue_kpops;
    }

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 3),
      height: height_eachContents,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: AutoSizeText(
              capitalize(contents),
              textAlign: TextAlign.left,
              maxLines: 1,
              minFontSize: 10,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          DropdownButton(
            isDense: true,
            iconEnabledColor: MyTheme.kAccentColor,
            dropdownColor: MyTheme.kAccentColor,
            borderRadius: BorderRadius.circular(10),
            underline: const SizedBox.shrink(),
            value: ref.watch(dropdownValue),
            items: listContentsRange.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Container(
                  width: 30,
                  padding: const EdgeInsets.only(right: 5),
                  alignment: Alignment.centerRight,
                  child: Center(
                    child: AutoSizeText(
                      value.toString(),
                      minFontSize: 10,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ),
              );
            }).toList(),
            onChanged: (value) {
              ref.watch(dropdownValue.notifier).state = value!;

              // Write the value to local file.
              configMap_newsroom?[contents] = value;
              ref.watch(contentsLimitNewsRoom.notifier).state = configMap_newsroom!;
              writeConfig('newsroom', jsonEncode(configMap_newsroom).toString());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    viewWidth = MediaQuery.of(context).size.width * 0.65;

    double marginTop = MediaQuery.of(context).viewPadding.top + kToolbarHeight;

    const viewHeight_extra = 50;
    final viewHeight = listWrapperRow(context, ref).length * height_eachTitle
        + listTileContents(context, ref).length * height_eachContents
        + viewHeight_extra;

    readConfig('newsroom').then((value) {
      configMap_newsroom = value;
    });

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: marginTop,
          right: 10
        ),
        child: SizedBox(
          width: viewWidth,
          height: viewHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Drawer(
              backgroundColor: MyTheme.kPrimaryColor.withOpacity(0.95),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: listWrapperRow(context, ref),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//// ExpansionTile => 단순 ListView로 바꾸기.