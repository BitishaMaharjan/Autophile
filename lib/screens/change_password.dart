import 'package:autophile/core/toast.dart';
import 'package:autophile/screens/auth/forgot_password.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/app_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final storage = FlutterSecureStorage();

  void _savePassword() async {
    final userId = await storage.read(key: 'userId');
    if (userId == null) {
      ToastUtils.showError("User not found. Please log in again.");
      return;
    }

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ToastUtils.showError("Fields cannot be empty.");
      return;
    }

    if (newPassword != confirmPassword) {
      ToastUtils.showError("New passwords do not match.");
      return;
    }

    if (newPassword.length < 8) {
      ToastUtils.showError("New password must be at least 8 characters long.");
      return;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        ToastUtils.showError("User not found.");
        return;
      }

      final storedHashedPassword = docSnapshot.data()?['password'];

      if (!BCrypt.checkpw(currentPassword, storedHashedPassword)) {
        ToastUtils.showError("Current password is incorrect.");
        return;
      }

      final hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'password': hashedNewPassword});

      ToastUtils.showSuccess("Password changed successfully.");
      Navigator.pop(context);
    } catch (e) {
      ToastUtils.showError("Error: ${e.toString()}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Change Password',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),),
               SizedBox(height: 20,),
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
    );
  }
}
