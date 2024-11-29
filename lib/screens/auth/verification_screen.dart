import 'package:bdcalling_it/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  const OTPVerificationPage({super.key, required this.email});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  void _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await _authService.activateUser(
      email: widget.email,
      code: _otpController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'Success') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified Successfully')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter the 6-digit OTP sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text('Verify OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
