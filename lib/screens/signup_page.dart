import 'package:autophile/screens/login_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


const String userAgreementContent = '''
Welcome to Autophile! Please read this User Agreement carefully before creating an account.

**1. Account Creation**:
   - You must provide accurate, current, and complete information during the signup process.
   - You are responsible for maintaining the confidentiality of your account credentials.
   - You agree to notify us immediately if you suspect unauthorized access to your account.

**2. User Responsibilities**:
   - You agree to use Autophile in compliance with all applicable laws and regulations.
   - You will not engage in any activities that disrupt the platform or harm other users.
   - You are responsible for all activities that occur under your account.

**3. Prohibited Activities**:
   - No unauthorized access, hacking, or misuse of Autophile services.
   - No posting of illegal, harmful, or offensive content.
   - No spamming, fraud, or deceptive practices.

**4. Intellectual Property**:
   - All content, logos, and services provided by Autophile are protected by copyright and trademark laws.
   - You may not copy, distribute, or modify Autophile’s content without permission.

**5. Termination**:
   - Autophile reserves the right to suspend or terminate your account if you violate these terms.
   - You may terminate your account at any time by contacting support.

**6. Limitation of Liability**:
   - Autophile is not liable for any damages resulting from the use or inability to use the platform.
   - The platform is provided "as is" without warranties of any kind.

By creating an account, you agree to abide by these terms and conditions. If you do not agree, please do not use Autophile.
''';


const String privacyPolicyContent = '''
**Autophile Privacy Policy**

**1. Data Collection**:
   - We collect personal information such as your email address, name, and password during account creation.
   - We may collect usage data, such as app interactions, to improve our services.

**2. How We Use Your Data**:
   - To provide, maintain, and improve our services.
   - To personalize your user experience.
   - To communicate with you regarding updates, support, and promotional offers.

**3. Data Sharing**:
   - We do not sell or share your personal data with third parties without your consent.
   - We may share data with trusted partners who assist us in operating the app, subject to confidentiality agreements.

**4. Data Security**:
   - We implement security measures such as encryption to protect your data.
   - While we strive to protect your information, no method of transmission is 100% secure.

**5. User Rights**:
   - You have the right to access, modify, or delete your personal data.
   - You can request data deletion by contacting our support team.

**6. Cookies and Tracking**:
   - We may use cookies or similar tracking technologies to analyze usage patterns and improve the app.
   
**7. Children’s Privacy**:
   - Autophile is not intended for children under 13. We do not knowingly collect data from children.

**8. Changes to this Policy**:
   - We may update this Privacy Policy periodically. You will be notified of significant changes.

**9. Contact Us**:
   - If you have questions or concerns about this Privacy Policy, please contact us at support@autophile.com.

By using Autophile, you consent to the practices outlined in this Privacy Policy.
''';



class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

  bool _isEmailValid=false;
  String _email='';
  bool _isPasswordHidden=true;
  bool _isChecked=false;

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[cC][oO][mM]$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Material(
            color: Theme.of(context).colorScheme.surface,
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
                    Text("Email address",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),),
                    SizedBox(height: 6,),
                      TextField(
                        onChanged: (value){
                          setState(() {
                            _email=value;
                            _isEmailValid=emailRegex.hasMatch(_email);
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffD8DADC),

                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          suffixIcon: _isEmailValid ?Icon(
                            Icons.check_circle,
                          ):null,
                        ),
                      ),
                    SizedBox(height: 17,),
                    Text("Create a Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    SizedBox(height: 6,),
                    TextField(
                      obscureText: _isPasswordHidden,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffD8DADC),

                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordHidden ? Icons.visibility_off: Icons.visibility,),
                            onPressed: (){
                              setState(() {
                                _isPasswordHidden= !_isPasswordHidden;
                              });
                            },
                          )
                      ),
                    ),
                    SizedBox(height: 17,),
                    Text("Confirm Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    SizedBox(height: 6,),
                    TextField(
                      obscureText: _isPasswordHidden,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffD8DADC),

                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius:BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordHidden ? Icons.visibility_off: Icons.visibility,),
                            onPressed: (){
                              setState(() {
                                _isPasswordHidden= !_isPasswordHidden;
                              });
                            },
                          )
                      ),
                    ),

                    SizedBox(height: 22,),
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
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: " User Agreement",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,

                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap=(){
                                _showPopup(context,"User Agreement",userAgreementContent);
                                }
                            ),
                            TextSpan(text:" and ",
                            style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(text: "Privacy Policy",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,

                            ),
                            recognizer: TapGestureRecognizer()
                            ..onTap=(){
                              _showPopup(context,"Privacy Policy",privacyPolicyContent,);
                            })
                          ]
                        )))
                      ],
                    ),

                    SizedBox(height: 22,),
                    AppButton(text: "Sign up", onTap: (){}),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            width: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color:Color(0xffD8DADC)),
                              borderRadius: BorderRadius.circular(10),

                            ),
                            padding: EdgeInsets.all(15),
                            child: Image.asset(
                              'assets/images/social_icons/Facebook.png',
                              height: 20,
                              width: 20,

                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            width: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Color(0xffD8DADC)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Image.asset(
                              'assets/images/social_icons/Googlelogo.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 113,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                          style: TextStyle(
                            fontSize:17,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> Login_Page()),);

                          },
                          child: Text("Sign in",
                            style: TextStyle(
                              fontSize: 17,
                              color:Colors.blueGrey,
                              fontWeight: FontWeight.w400,
                            ),),
                        )
                      ],
                    )



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
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 500,
            child: SingleChildScrollView(
              child: Text(
                content,
                style: TextStyle(fontSize: 14, height: 1.2),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          actions: [
              SizedBox(
                width: 400,
                height: 70,
                child: AppButton(
                  text: "Close",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
          ],



        );
      },
    );
  }



}



