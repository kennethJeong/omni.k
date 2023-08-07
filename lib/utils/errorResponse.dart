import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_config/flutter_config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ErrorResponse {

  Future<void> errorReport(String error) async {
    var body = 'DateTime: ${DateTime.now()}';
    // body += '\n Point: $point';
    // body += '\n Content: $content';
    body += '\n ErrorContent: $error';

    String username = 'dev.kennyJ@gmail.com';
    String password = Platform.isAndroid ?
    FlutterConfig.get('gmail_pw_aos').toString() :
    FlutterConfig.get('gmail_pw_ios').toString();
    String bccUsername = 'eunuism@gmail.com';

    var smtpServer = gmail(username, password);
    final equivalentMessage = Message()
      ..from = Address(username, 'Omni.K')
      ..subject = '[Error Report [Omni.K]] :: ${DateTime.now()}'
      ..recipients.add(Address(username))
      ..bccRecipients.add(Address(bccUsername))
      ..text = body;

    await send(equivalentMessage, smtpServer);
  }

  void errorAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          title: const Center(
            child: Text(
              "ERROR",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "An error has occurred.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  "The matter has been forwarded to the person in charge, and we will take care of it as soon as possible.",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  "I'm sorry for the inconvenience.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text("Confirm"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }
}

