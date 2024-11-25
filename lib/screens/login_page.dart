import 'package:autophile/widgets/app_button.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  bool _isPasswordHidden=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),

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
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ],
              ),
              SizedBox(height: 80,),
              Text("Email address",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),),
              SizedBox(height: 10,),
              TextField(
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
                  )
                ),
              ),
              
              SizedBox(height: 20,),
              Text("Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),),
              SizedBox(height: 10,),
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
              SizedBox(height: 5,),
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
              SizedBox(height: 20,),
              AppButton(text: "Sign in", onTap: (){})
            ],
          ),
        ),
      ),
    );
  }
}
