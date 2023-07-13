import 'dart:math';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class OtpHandler {
  BuildContext _buildContext;
  OtpHandler(BuildContext buildContext) {
    this._buildContext = buildContext;
  }

  static TwilioFlutter _twilioFlutter = new TwilioFlutter(
    accountSid: 'AC5cc37e51ad8844a622f3cfb296d8548d',
    authToken: 'fa22ccc6986cdf1d4d9957ff5f619695',
    twilioNumber: '+16062689438'
  );

  String sendOtp(String phoneNumber) {
    String _verificationCode = _generateVerificationCode();

    try {
      _twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: _verificationCode + ' is your AP Lib verification code.',
      );
    } catch (ex) {
      ScaffoldMessenger.of(_buildContext).showSnackBar(
        SnackBar(
          content: Text(
            'Phone number exists.',
            style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
          ),
          backgroundColor: Constants.COLOR_RED,
        ),
      );
    }

    return _verificationCode;
  }

  // void sendOtp(String phoneNumber) async {
  //   String _verificationCode = _generateVerificationCode();
  //   // d988119e862c83a734d61a47edfc71caa48a65fc
  //   print(phoneNumber);
  //   var url = Uri.parse(
  //       'https://api.ringcaptcha.com/ygi4ufuza3o3oli5i2ap/code/sms?' +
  //           'api_key=d988119e862c83a734d61a47edfc71caa48a65fc' +
  //           '&phone=$phoneNumber'
  //   );
  //   var response = await http.post(url,
  //     headers: <String, String> {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //
  //   print(response.body);
  // }

  // void verifyNumber(String phoneNumber, String code) async {
  //   var url = Uri.parse(
  //       'https://api.ringcaptcha.com/ygi4ufuza3o3oli5i2ap/verify?' +
  //           'api_key=d988119e862c83a734d61a47edfc71caa48a65fc' +
  //           '&phone=$phoneNumber' +
  //           '&code=$code'
  //   );
  //   var response = await http.post(url,
  //     headers: <String, String> {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   print(response.body);
  // }

  String _generateVerificationCode() {
    var random = new Random();
    var next = random.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt().toString();
  }

  Future<bool> sendOtpEmail(String email) async {
    EmailAuth.sessionName = "OTP Authentication";

    var data = await EmailAuth.sendOtp(receiverMail: email);

    return data;
  }

  bool verify(String email, String otp) {
    return EmailAuth.validate(
      receiverMail: email,
      userOTP: otp
    );
  }
}