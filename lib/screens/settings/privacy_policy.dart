import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
Privacy Policy

Thank you for choosing our Money Management App. We are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, and protect the information you provide while using our app.

Information Collection and Use:
We do not collect any personal information or financial data from you. Our app operates locally on your device and does not transmit any data to our servers or any third-party services. All your financial information and transaction data remain securely stored on your device's local memory.

Data Security:
We take the security of your data seriously. We have implemented robust measures to safeguard your information from unauthorized access or disclosure. Your financial data is encrypted and stored securely on your device. We recommend that you use additional security measures, such as passcodes or biometric authentication, to protect your device from unauthorized access.

Data Sharing:
Since we do not collect any personal or financial data, we do not share your information with any third parties. Your data remains private and is solely accessible to you on your device.

Changes to the Privacy Policy:
We reserve the right to modify or update this Privacy Policy at any time. Any changes made to the policy will be effective immediately upon posting the updated version within the app. We encourage you to review this Privacy Policy periodically for any changes.

Contact Us:
If you have any questions or concerns regarding our Privacy Policy or the handling of your data, please contact us at Email: raeesrazi123@gmail.com. We will be glad to assist you and address any concerns you may have.

By using our Money Management App, you agree to the terms outlined in this Privacy Policy.

Last updated: 27/06/2023

Note: This is a general template for a privacy policy and may need customization to fit your specific app and requirements. It is advisable to consult with legal professionals to ensure compliance with relevant privacy laws and regulations in your jurisdiction.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
