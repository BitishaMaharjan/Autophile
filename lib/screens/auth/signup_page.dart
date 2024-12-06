import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/screens/auth/verify_email_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autophile/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isChecked=false;

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
      showErrorToast('Something went wrong while sending OTP');
    }
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> signUp() async {
    if(!_isChecked){
      showErrorToast('Please agree to user agreement to continue');
      return;
    }
    if (!emailRegex.hasMatch(emailController.text)) {
      showErrorToast('Invalid Email Format');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showErrorToast('Password do not match');
      return;
    }

    if (passwordController.text.length < 8) {
      showErrorToast('Password must be at least 8 characters long');
      return;
    }

    try {
      final checkEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (checkEmail.docs.isNotEmpty) {
        showErrorToast('Email is already in use');
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      sendOTP();
    } catch (e) {
      print("Error during signup: $e");
      showErrorToast(e.toString());
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
                                _showPopup(context,"User Agreement","This is user agreement");
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
                              _showPopup(context,"Privacy Policy","This is privacy policy");
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
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}


