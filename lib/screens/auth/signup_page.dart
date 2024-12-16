import 'package:autophile/core/toast.dart';
import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/screens/auth/verify_email_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autophile/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:autophile/core/loading.dart';

const String userAgreementContent = '''
Welcome to Autophile! Please read this User Agreement carefully before creating an account.

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


const String privacyPolicyContent = '''
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

6. Cookies and Tracking:
- We may use cookies or similar tracking technologies to analyze usage patterns and improve the app.

7. Children’s Privacy:
- Autophile is not intended for children under 13. We do not knowingly collect data from children.

8. Changes to this Policy:
- We may update this Privacy Policy periodically. You will be notified of significant changes.

9. Contact Us:
- If you have questions or concerns about this Privacy Policy, please contact us at support@autophile.com.

By using Autophile, you consent to the practices outlined in this Privacy Policy.
''';



class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isChecked=false;
  bool isLoading = false;

  void sendOTP()async{
    EmailOTP.config(
      appName: 'Autophile',
      otpType: OTPType.numeric,
      expiry : 60000,
      emailTheme: EmailTheme.v3,
      appEmail: 'info@autophile.com',
      otpLength: 6,
    );
    bool result = await EmailOTP.sendOTP(email: emailController.text);
    if(result){
      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage(email: emailController.text)));
    }else{
      ToastUtils.showError('Something went wrong while sending OTP');
    }
  }


  Future<void> signUp() async {
    if(!_isChecked){
      ToastUtils.showError('Please agree to user agreement and privacy policy to continue');
      return;
    }
    if (!emailRegex.hasMatch(emailController.text)) {
      ToastUtils.showError('Invalid Email Format');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ToastUtils.showError('Password do not match');
      return;
    }

    if (passwordController.text.length < 8) {
      ToastUtils.showError('Password must be at least 8 characters long');
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LottieLoadingComponent(animationPath: 'assets/animation/loading.json'), // Show the Loading component
    );

    try {
      final checkEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (checkEmail.docs.isNotEmpty) {
        ToastUtils.showError('Email is already in use');
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      
      String hashedPassword = BCrypt.hashpw(passwordController.text, BCrypt.gensalt());

      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: nameController.text,
        email: emailController.text,
        password: hashedPassword,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      sendOTP();
    } catch (e) {
      print("Error during signup: $e");
      ToastUtils.showError(e.toString());
    }finally {
      Navigator.pop(context);
    }
  }

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[cC][oO][mM]$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:const EdgeInsets.only(
                top:18,
                left:20,
                right:20,

              ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text("Create an\naccount",
                              style: TextStyle(
                                fontSize: 30.41,
                                fontWeight: FontWeight.w700,
                              ),),
                          ),
                          Image.asset(
                            'assets/images/autophile_logo/logo.png',
                            height: 100,
                          )
                        ],
                      ),
                    SizedBox(height: 39,),
                    AppTextField(
                      controller: nameController,
                      hintText: "Enter your name",
                      labelText: 'Name',
                    ),
                    SizedBox(height: 17,),
                    AppTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      labelText: 'Email address',
                    ),
                    SizedBox(height: 17,),
                    AppTextField(
                      controller: passwordController,
                      hintText: 'must be 8 characters',
                      labelText: 'Create a Password',
                      obscureText: true,
                    ),
                    SizedBox(height: 17,),
                    AppTextField(
                      controller: confirmPasswordController,
                      hintText: 'repeat your password',
                      labelText: 'Confirm Password',
                      obscureText: true,
                    ),

                    SizedBox(height: 12,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(value: _isChecked, onChanged: (value){
                          setState(() {
                            _isChecked=value!;
                          });

                        }),
                        Expanded(child: RichText(text: TextSpan(
                          text: "I have read and agreed to",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: " User Agreement",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w400,

                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap=(){
                                _showPopup(context,"User Agreement",userAgreementContent);
                                }
                            ),
                            TextSpan(text:" and "),
                            TextSpan(text: "Privacy Policy",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,

                            ),
                            recognizer: TapGestureRecognizer()
                            ..onTap=(){
                              _showPopup(context,"Privacy Policy",privacyPolicyContent);
                            })
                          ]
                        )))
                      ],
                    ),

                    SizedBox(height: 12,),
                    AppButton(text: "Sign up", onTap: signUp),
                    SizedBox(height: 28,),
                    Row(
                      children: [
                        Expanded(child: Divider(color:Colors.grey),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text("Or",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                            ),),),
                        Expanded(child: Divider(color: Colors.grey,))
                      ],
                    ),
                    SizedBox(height: 28,),
                    SizedBox(height: 13,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                          style: TextStyle(
                            fontSize:17,
                            fontWeight: FontWeight.w400,),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> Login_Page()),);

                          },
                          child: Text("Sign in",
                            style: TextStyle(
                              fontSize: 17,
                              color:Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                            ),),
                        ),

                      ],
                    ),



                  ],

                ),
              ),
          )),

    );
  }
  void _showPopup(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 14, height: 1.2),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      text: "Close",
                      onTap: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}


