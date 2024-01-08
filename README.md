# SMS OTP Verification Service for Flutter
# autofill_otp
The `autofill_otp` package provides a Flutter widget for OTP (One-Time Password) verification, with SMS autofill functionality.

## Features

- We need to give the mobile number and the application ID with the SMS format.
- This package contains a 60-second timer. If the One-Time Password (OTP) is not entered,
  the resend text can be used to request the OTP to be resent for automatic filling.
- if the two-factor authentication process is successful, we can proceed to the next screen by clicking the 'Verify' button.

## Getting started
Import

```dart
import 'package:autofill_otp/autofill_otp.dart';
```

## Implement the VerifyOTPScreen Widget
```dart
VerifyOTPScreen(
onVerification: (bool isVerified) {
// Handle verification status
if (isVerified) {
// Navigate to the next screen or perform further actions
} else {
// Handle failed verification
}
},
imagePath: 'assets/your_image.png',
buttonColor: Colors.blue,
)
```
## Widget Properties
- onVerification: A callback function to handle the verification status.
- imagePath: Path to the image to be displayed on the verification screen.
- buttonColor: Color of the verification button.

# Integration
Add sms_autofill: ^2.3.0 package to your pubspec.yaml to get the application id for the mobile number and also this  autofill_otp: ^1.0.0

```yaml
dependencies:
  sms_autofill: ^2.3.0
```
This is how you can use this below method to get the application ID
```dart
  static void submit(BuildContext context,
      TextEditingController mobileNumberController) async {
    if (mobileNumberController.text == "") return;
    //for getting the app signature ID
    var appSignatureID = await SmsAutoFill().getAppSignature;
    //send the otp using the app signature id to the allotted mobile number
    Map sendOtpData = {
      "mobile_number": mobileNumberController.text,
      "app_signature_id": appSignatureID
    };
    print(sendOtpData);
    //on click the submit btn we navigate user to the verify otp screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  VerifyOTPScreen(
                onVerification: (bool isVerified) {
                  if (isVerified) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondScreen()));
                  } else {
                    print("OTP not yet filled");
                  }
                }, imagePath:   'assets/images/illustration-1.png', buttonColor: Colors.blue,
              )),
    );
  }
```

## SMS format example

```dart
  <#>your code 0010 M+9NJY0hsG/
```
here M+9NJY0hsG/ is the application id for particular app
and we can edit our msg at the place of your code

## Installation

To use this package, add `autofill_otp` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  autofill_otp: ^1.0.0
```

## Additional information
- Example
```dart

import 'package:auto_read_sms_otp/auto_read.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController mobileNumber = TextEditingController();//controller for mobile number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //btn used tp submit the mobile and generate the app signature is via the submitting method called on the click of this btn
      ElevatedButton(
        onPressed: (){
          AutoReadOTP.submit(context, mobileNumber);
        },
        child: const Text("Submit"),
      ),
      const SizedBox(
        height: 20,
      ),
    );
  }
}
```
we have to pass the image path and color for button and resend msg text

```dart
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'auto_read_sms_otp.dart';

class AutoReadOTP {
  //submit button functionality for getting the app signature id and mobile number on which the otp is being sent
  static void submit(BuildContext context,
      TextEditingController mobileNumberController) async {
    if (mobileNumberController.text == "") return;
    //for getting the app signature ID
    var appSignatureID = await SmsAutoFill().getAppSignature;
    //send the otp using the app signature id to the allotted mobile number
    Map sendOtpData = {
      "mobile_number": mobileNumberController.text,
      "app_signature_id": appSignatureID
    };
    print(sendOtpData);
    //on click the submit btn we navigate user to the verify otp screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  VerifyOTPScreen(//you can use this package class for otp verification
                onVerification: (bool isVerified) {
                  if (isVerified) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondScreen()));
                  } else {
                    print("OTP not yet filled");
                  }
                }, imagePath: 'assets/images/illustration-1.png', buttonColor: Colors.blue,
              )),
    );
  }
}
```

## Acknowledgments
Special thanks to the sms_autofill package for providing SMS autofill functionality.