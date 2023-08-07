//
// Move the web based on the link
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String link) async {
  final url = Uri.parse(link);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}