import 'package:autophile/widgets/app_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController otpController = TextEditingController();
  String message = '';

  void sendOTP()async{
    EmailOTP.config(
      appName: 'Autophile',
      otpType: OTPType.numeric,
      expiry : 60000,
      emailTheme: EmailTheme.v3,
      appEmail: 'info@autophile.com',
      otpLength: 6,
    );
    bool result = await EmailOTP.sendOTP(email: widget.email);
    if(result){
      setState(() {
        message = 'New OTP is sent to your email';
      });
    }else{
      setState(() {
        message = 'Failed to resend OTP';
      });
    }
  }

  void verifyOTP() async {
    setState(() {
      message = 'Verifying OTP...';
    });

    bool isValid = await EmailOTP.verifyOTP(
      otp: otpController.text,
    );

    if (isValid) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(doc.id)
                .update({'isVerified': true});
          }
        });

        setState(() {
          message = 'OTP Verified Successfully!';
        });

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/home');
        });
      } catch (e) {
        setState(() {
          message = 'Error updating user: $e';
        });
      }
    } else {
      setState(() {
        message = 'Invalid OTP. Please try again.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Verify Email',
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the 6-digit code sent to your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: message.isNotEmpty ? 1.0 : 0.0,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: message == 'OTP Verified Successfully!'
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(controller: otpController, hintText: "Enter OTP", labelText: ''),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => verifyOTP(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: sendOTP,
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
