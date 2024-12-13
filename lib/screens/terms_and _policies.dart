import 'package:flutter/material.dart';

class TermsAndPoliciesScreen extends StatefulWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  _TermsAndPoliciesScreenState createState() => _TermsAndPoliciesScreenState();
}

class _TermsAndPoliciesScreenState extends State<TermsAndPoliciesScreen> {
  final Map<String, bool> _sectionExpanded = {
    'Terms of Service': false,
    'Privacy Policy': false,
    'Community Guidelines': false,
  };

  Widget _buildExpandableSection(String title, String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: _sectionExpanded[title]!,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  final String _userAgreementContent = '''
1. Account Creation:
- You must provide accurate, current, and complete information during the signup process.
- You are responsible for maintaining the confidentiality of your account credentials.
- You agree to notify us immediately if you suspect unauthorized access to your account.

2. User Responsibilities:
- You agree to use Autophile in compliance with all applicable laws and regulations.
- You will not engage in any activities that disrupt the platform or harm other users.
- You are responsible for all activities that occur under your account.

3. Prohibited Activities:
- No unauthorized access, hacking, or misuse of Autophile services.
- No posting of illegal, harmful, or offensive content.
- No spamming, fraud, or deceptive practices.

4. Intellectual Property:
- All content, logos, and services provided by Autophile are protected by copyright and trademark laws.
- You may not copy, distribute, or modify Autophile’s content without permission.

5. Termination:
- Autophile reserves the right to suspend or terminate your account if you violate these terms.
- You may terminate your account at any time by contacting support.

6. Limitation of Liability:
- Autophile is not liable for any damages resulting from the use or inability to use the platform.
- The platform is provided "as is" without warranties of any kind.

By creating an account, you agree to abide by these terms and conditions. If you do not agree, please do not use Autophile.
''';

  final String _privacyPolicyContent = '''
Autophile Privacy Policy

1. Data Collection:
- We collect personal information such as your email address, name, and password during account creation.
- We may collect usage data, such as app interactions, to improve our services.

2. How We Use Your Data:
- To provide, maintain, and improve our services.
- To personalize your user experience.
- To communicate with you regarding updates, support, and promotional offers.

3. Data Sharing:
- We do not sell or share your personal data with third parties without your consent.
- We may share data with trusted partners who assist us in operating the app, subject to confidentiality agreements.

4. Data Security:
- We implement security measures such as encryption to protect your data.
- While we strive to protect your information, no method of transmission is 100% secure.

5. User Rights:
- You have the right to access, modify, or delete your personal data.
- You can request data deletion by contacting our support team.

6. Children’s Privacy:
- Autophile is not intended for children under 13. We do not knowingly collect data from children.

7. Changes to this Policy:
- We may update this Privacy Policy periodically. You will be notified of significant changes.

8. Contact Us:
- If you have questions or concerns about this Privacy Policy, please contact us at support@autophile.com.

By using Autophile, you consent to the practices outlined in this Privacy Policy.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Policies'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildExpandableSection('Terms of Service', _userAgreementContent),
            _buildExpandableSection('Privacy Policy', _privacyPolicyContent),
            _buildExpandableSection(
              'Community Guidelines',
              '''
We are committed to fostering a safe and respectful community.

Guidelines:
- Be respectful to other users.
- No posting of harmful, offensive, or illegal content.
- Report violations to help keep the community safe.
''',
            ),
          ],
        ),
      ),
    );
  }
}
