import 'package:autophile/screens/auth/forgot_password.dart';
import 'package:autophile/screens/auth/signup_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/screens/dashboard/base_screen.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // bool _isEmailValid=false;
  // String _email='';
  bool _isPasswordHidden=true;

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[cC][oO][mM]$');
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
                AppButton(text: "Sign in", onTap: () {
                  // Perform sign-in logic here (e.g., validation/authentication)
                  Navigator.pushNamed(
                    context,
                    '/home'
                  );
                },),
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