import 'package:flutter/material.dart';

class OTPPAGE extends StatelessWidget {
  void _sendOTP(BuildContext ctx) {
    ScaffoldMessenger.of(
      ctx,
    ).showSnackBar(SnackBar(content: Text('OTP Sent Successfuly')));
    Future.delayed(
      Duration(seconds: 1),
      () => Navigator.pushNamed(ctx, '/otp'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send OTP")),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            minimumSize: Size(150, 40),
          ),
          onPressed: () => _sendOTP(context),
          icon: Icon(Icons.send),
          label: Text("Send OTP"),
        ),
      ),
    );
  }
}
