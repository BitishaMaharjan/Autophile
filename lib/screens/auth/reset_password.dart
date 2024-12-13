import 'package:autophile/core/toast.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:autophile/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void resetPassword() async {
    String newPassword = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ToastUtils.showError('Fields cannot be empty');
      return;
    }

    if (newPassword.length < 8) {
      ToastUtils.showError('Password must be at least 8 characters long');
      return;
    }

    if (newPassword != confirmPassword) {
      ToastUtils.showError('Passwords do not match');
      return;
    }

    try {
      String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      await _firestore
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'password': hashedPassword});
          ToastUtils.showSuccess('Password reset successfully');
          Navigator.pushReplacementNamed(
            context,
            '/auth',
          );
        } else {
          showSnackBar('User not found');
        }
      });
    } catch (e) {
      print(e.toString());
      showSnackBar('Error resetting password');
    }
  }


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                      fontWeight: FontWeight.bold,
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
                  AppButton(
                    text: 'Reset password',
                    onTap: resetPassword,
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember password?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login_Page()));
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
