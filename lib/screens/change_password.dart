import 'package:autophile/screens/auth/forgot_password.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:flutter/material.dart';
import '../widgets/app_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      // Placeholder for saving the new password
      print('Password changed successfully');
    }
  }

  void _forgotPassword() {
    // Placeholder for forgotten password functionality
    print('Forgotten password action');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions for Password Change
              const Text(
                'Please ensure your new password meets the following requirements:\n\n'
                    '• At least 8 characters long\n'
                    '• Contains both uppercase and lowercase letters\n'
                    '• Includes at least one number\n'
                    '• Contains at least one special character (e.g., @, #, \$, %)',
                style: TextStyle(fontSize: 14,),
              ),
              const SizedBox(height: 30),

              // Current Password
              AppTextField(
                controller: _currentPasswordController,
                hintText: 'Enter your current password',
                labelText: 'Current Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // New Password
              AppTextField(
                controller: _newPasswordController,
                hintText: 'Enter a new password',
                labelText: 'New Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Confirm New Password
              AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Re-enter new password',
                labelText: 'Confirm New Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Forgotten Password Link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword(),));
                  },
                  child: Text(
                    'Forgotten your password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              AppButton(
                text: "Change Password",
                onTap: _savePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
