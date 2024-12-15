import 'package:autophile/core/toast.dart';
import 'package:autophile/models/user_model.dart';
import 'package:autophile/screens/auth/signup_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLogoAtTop = false;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }


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

  void _startAnimation() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _isLogoAtTop = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/landing_background.png',
              fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.surface
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _isLogoAtTop ? 50 : screenHeight / 3 - 50,
            left: (screenWidth - 200) / 2+20,
            child: SizedBox(
              width: 200,
              height: 250,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 300),
                  AppButton(text: 'Sign in', onTap: (){Navigator.pushNamed(context, '/auth');}),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/social_icons/Googlelogo.png' ,width: 20, fit: BoxFit.contain,),
                          SizedBox(width: 40),
                          Text(
                            'Continue with Google'
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/social_icons/Facebook.png' ,width: 20, fit: BoxFit.contain,),
                          SizedBox(width: 40),
                          Text(
                            'Continue with Facebook'
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height:100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                        },
                        child:
                        Text('Sign up',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
