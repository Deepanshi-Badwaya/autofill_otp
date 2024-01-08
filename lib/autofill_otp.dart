library autofill_otp;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

// Callback signature for notifying the parent widget about the verification status
typedef VerificationCallback = void Function(bool isVerified);

class VerifyOTPScreen extends StatefulWidget {
  VerifyOTPScreen({Key? key, required this.onVerification, required this.imagePath, required this.buttonColor}) : super(key: key);
  final String imagePath; // provide the imagePath
  final Color buttonColor;//button color
  final VerificationCallback onVerification;// Callback function to notify the parent widget about verified status

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> with CodeAutoFill{
  String codeValue = "";//code value
  late Timer _timer; // timer object of timer class
  int _timerDuration = 60; // in seconds

  // Clear OTP field and auto-fill new OTP
  void resendOtp() {
    setState(() {
      codeValue = "";
      _timerDuration = 60; // Reset the timer duration
      startTimer(); // Restart the timer when Resend is clicked
    });
    listenOtp();
  }

  // Timer function to update countdown
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration > 0) {
          _timerDuration--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  // Updated the OTP code
  @override
  void codeUpdated() {
    if (codeValue.length == 4) {
      // Check if the OTP is filled
      _timer.cancel(); // Stop the timer
      widget.onVerification(true);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
    } else {
      widget.onVerification(false);
    }
  }

  // Firstly the listenOtp func called for listening to the OTP
  @override
  void initState() {
    super.initState();
    listenOtp();
    startTimer();
  }

  // ListenOtp function to fetch the OTP and auto-fill it in the fields
  listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  // To stop the SMS stream listener inside dispose() method
  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff7f6fb),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    widget.imagePath,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We've sent you an OTP code via SMS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:Column(
                    children: [
                      Center(
                        child: PinFieldAutoFill(
                          currentCode: codeValue,
                          codeLength: 4,
                          decoration: UnderlineDecoration(
                            lineHeight: 2,
                            lineStrokeCap: StrokeCap.square,
                            bgColorBuilder: PinListenColorBuilder(
                                Colors.green.shade200, Colors.grey.shade200),
                            colorBuilder: const FixedColorBuilder(Colors.blue),
                          ),
                          //fill the fields with the listened otp
                          onCodeChanged: (code) {
                            setState(() {
                              codeValue = code.toString();
                            });
                          },
                          onCodeSubmitted: (val) {
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (codeValue.length == 4) {
                              // Check if the OTP is filled
                              _timer.cancel(); // Stop the timer
                              widget.onVerification(true);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
                            } else {
                              widget.onVerification(false);
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(widget.buttonColor),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Verify',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 18,
                ),
                TextButton(
                  onPressed: _timerDuration > 0 ? null : resendOtp, // Disable if timer is running
                  child:  Text(_timerDuration > 0 ? "Resend New Code ($_timerDuration s)" : "Resend New Code",
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timerDuration > 0 ? Colors.grey : widget.buttonColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}
