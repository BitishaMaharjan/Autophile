import 'package:autophile/screens/auth/signup_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/screens/dashboard/base_screen.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  
  bool _isEmailValid=false;
  String _email='';
  bool _isPasswordHidden=true;

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[cC][oO][mM]$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          color:Theme.of(context).colorScheme.surface,
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
                SizedBox(height: 113,),
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
                    hintText: "abc@gmail.com",
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
                Text("Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),),
                SizedBox(height: 6,),
                TextField(
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                      hintText: "Enter your password",
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
                SizedBox(height: 7,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed:() {

                  }, child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      color:Colors.blueAccent,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
                ),
                SizedBox(height: 35,),
                AppButton(text: "Sign in", onTap: () {
                  // Perform sign-in logic here (e.g., validation/authentication)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BaseScreen(
                        onCameraTapped: () {
                          // Camera functionality
                        },
                      ),
                    ),
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
                SizedBox(height: 113,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                    style: TextStyle(
                        fontSize:17,
                    color: Colors.black,
                      fontWeight: FontWeight.w400,),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> SignupPage()),);

                      },
                      child: Text("Sign up",
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
        ),
      ),
    );
  }
}
