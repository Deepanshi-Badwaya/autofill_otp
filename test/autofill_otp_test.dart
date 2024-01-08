import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autofill_otp/autofill_otp.dart';

void main() {
  test('otp auto fill', () {
    final otp = VerifyOTPScreen(onVerification: (bool isVerified) {  }, imagePath: '', buttonColor: Colors.white,);
    otp;
  });
}
