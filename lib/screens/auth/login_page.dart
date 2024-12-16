import 'package:autophile/core/toast.dart';
import 'package:autophile/models/user_model.dart';
import 'package:autophile/screens/auth/forgot_password.dart';
import 'package:autophile/screens/auth/signup_page.dart';
import 'package:autophile/screens/dashboard/base_screen.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:autophile/core/loading.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool isLoading = false;

  Future<void> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) {
        ToastUtils.showError("Failed to sign in with Google");
        return null;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? null,
          email: user.email!,
          isVerified: true,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());
      }

      await storage.write(key: 'userId', value: user.uid);

      ToastUtils.showSuccess('Welcome');

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
      });

    } catch (e) {
      ToastUtils.showError("Error: ${e.toString()}");
      return null;
    }
  }

  Future<void> login()async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LottieLoadingComponent(animationPath: 'assets/animation/loading.json'), // Show the Loading component
    );
    try{
      var queryResult = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: emailController.text).get();
      if(queryResult.docs.isEmpty){
        ToastUtils.showError('User not found!!!');
        return;
      }
      var result = queryResult.docs.first;

      String storedPassword = result['password'];
      if(BCrypt.checkpw(passwordController.text, storedPassword)){
        String userId = result['userId'];
        await storage.write(key: 'userId', value: userId);
        ToastUtils.showSuccess('Welcome');
        Future.delayed(Duration(seconds: 1),(){
          Navigator.pushReplacementNamed(context, '/home');});
      }else{
        ToastUtils.showError('Password is incorrect');
      }
    }catch(e){
      ToastUtils.showError(e.toString());
    }finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top:48,
              right: 20,
              left: 20,
              bottom: 44,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset(
                      'assets/images/autophile_logo/logo.png',
                      height: 100,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                AppTextField(controller: emailController, hintText: 'abc@example.com', labelText: "Email address"),
                SizedBox(height: 17,),
                AppTextField(controller: passwordController, hintText: 'Enter your password', labelText: "Password", obscureText: true,),
                SizedBox(height: 7,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed:() {

                  }, child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
                ),
                SizedBox(height: 35,),
                AppButton(text: "Sign in", onTap: login),
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
                      onTap: loginWithGoogle,
                      child: Container(
                        width: 180,
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
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                      style: TextStyle(
                        fontSize:17,
                        fontWeight: FontWeight.w400,),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> SignupPage()),);

                      },
                      child: Text("Sign up",
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
        ),
      ),
    );
  }
}
