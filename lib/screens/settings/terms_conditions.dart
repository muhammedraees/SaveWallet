import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
Terms and Conditions

Please read these Terms and Conditions carefully before using our Money Management App. By using the app, you agree to be bound by these terms. If you do not agree with any part of these terms, please refrain from using the app.

1. Use of the App:
The Money Management App is intended for personal financial management purposes only. You may use the app to track your income, expenses, and manage your financial transactions.

2. Data Privacy and Security:
We value your privacy and have implemented security measures to protect your personal and financial data. Please refer to our Privacy Policy for detailed information on how we collect, use, and protect your data.

3. Accuracy of Information:
While we strive to provide accurate and up-to-date information, we cannot guarantee the accuracy or completeness of the financial data, calculations, or any other information provided by the app. You are responsible for verifying the accuracy of any financial information and using it at your own discretion.

4. Financial Advice:
The Money Management App is not intended to provide financial advice. The app is a tool for personal financial management and does not substitute professional financial advice. We recommend consulting a qualified financial advisor for personalized financial guidance.

5. User Responsibilities:
By using the app, you agree to use it responsibly and abide by applicable laws and regulations. You are solely responsible for the use of the app and any actions taken based on the information provided. You must not use the app for any illegal or unauthorized purposes.

6. Intellectual Property:
All intellectual property rights related to the Money Management App, including but not limited to the app design, logo, graphics, and content, are owned by us. You are not permitted to use, modify, reproduce, distribute, or create derivative works of any part of the app without our prior written consent.

7. Limitation of Liability:
We shall not be held liable for any direct, indirect, incidental, consequential, or special damages arising out of or in connection with the use of the app. We do not warrant the app's uninterrupted or error-free operation, and we disclaim all warranties, expressed or implied.

8. Modification of Terms:
We reserve the right to modify or update these Terms and Conditions at any time. Any changes made to the terms will be effective immediately upon posting the updated version within the app. We encourage you to review the terms periodically for any changes.

9. Governing Law:
These Terms and Conditions shall be governed by and construed in accordance with the laws of India. Any disputes arising out of or in connection with these terms shall be subject to the exclusive jurisdiction of the courts in India.

If you have any questions or concerns regarding these Terms and Conditions, please contact us at Email: raeesrazi123@gmail.com . 

Last updated: 27/06/2023

Note: This is a general template for terms and conditions and may need customization to fit your specific app and requirements. It is advisable to consult with legal professionals to ensure compliance with relevant laws and regulations in your jurisdiction.
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
