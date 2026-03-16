import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpenso/color.dart';
import 'package:xpenso/customappbar.dart';
import 'customappbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String _appVersion = '1.0.0';

  Future<void> privacyPolicy() async {
  if (!await launchUrl(Uri.parse('https://sites.google.com/view/privacy-policy-shahzad-/home'))) {
    throw Exception('Could not launch url');
  }
}
  Future<void> termsCondition() async {
  if (!await launchUrl(Uri.parse('https://sites.google.com/view/terms-conditions-for-shahzad-/home'))) {
    throw Exception('Could not launch url');
  }
}

 Future<void> emailopen() async {
  if (!await launchUrl(Uri.parse("mailto:shahzadhussain34553@gmail.com "))){
throw Exception("Could not launch url");
  }

 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings', showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: primaryEnd,
                ),
                title: const Text('Privacy Policy'),
                onTap: () {
                 privacyPolicy();
                },
              ),
            ),
                 Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: primaryEnd,
                ),
                title: const Text('Terms & Condition'),
                onTap: () {
                 termsCondition();
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(Icons.support_agent, color: primaryEnd),
                title: const Text('Help & Support'),
                onTap: () {
                emailopen();
                },
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Version $_appVersion',
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
