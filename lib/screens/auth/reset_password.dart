import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_open_rounded,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 150,
                  )
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Reset Password',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Please type something you'll remember",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: passwordController,
                hintText: 'must be 8 characters',
                labelText: 'New Password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: confirmPasswordController,
                hintText: 'repeat password',
                labelText: 'Confirm new password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              AppButton(text: 'Reset password', onTap: (){}),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Remember password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Page()));
                    },
                    child:
                    Text('Sign in',
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
    );
  }
}
