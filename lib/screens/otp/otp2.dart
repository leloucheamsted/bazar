import 'package:bazar/widgets/countdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/palette.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../screens.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  String phone = "+237" + Get.arguments;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    //color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  late AnimationController _controller;
  int levelClock = 120;
  @override
  void initState() {
    _verifyPhone();
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));

    _controller.forward();

    if (kDebugMode) {
      print(phone);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // _verifyPhone().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Palette.colorLight,
        //iconTheme: IconThemeData(color: Palette.colorText),
        centerTitle: true,
        title: const Text('mokolo',
            style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'Prompt_Bold',
                color: Palette.primaryColor)),
      ),
      backgroundColor: Palette.colorLight,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text(
                '6-digit code',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Prompt_Bold',
                  color: Palette.colorText,
                ),
              ),
              const Text(
                'Please enter the code we’ve sent by SMS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Prompt_Regular',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                focusNode: _pinPutFocusNode,
                animationDuration: const Duration(milliseconds: 10),
                animationCurve: Curves.easeInOut,
                controller: _pinPutController,
                pinAnimationType: PinAnimationType.fade,
                onCompleted: (_pinPutController) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode!,
                            smsCode: _pinPutController))
                        .then((value) async {
                      FocusScope.of(context).previousFocus();
                      Get.to(
                        const SetupAccountScreen(),
                        arguments: phone,
                        transition: Transition.rightToLeft,
                        duration: const Duration(seconds: 1),
                      );
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState!
                        // ignore: deprecated_member_use
                        .showSnackBar(
                            const SnackBar(content: Text('invalid OTP')));
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Resend code in ',
                    style: TextStyle(
                        fontFamily: "Prompt_Regular",
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Palette.colorText),
                  ),
                  Countdown(
                    animation: StepTween(
                      begin: levelClock, // THIS IS A USER ENTERED NUMBER
                      end: 0,
                    ).animate(_controller),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            CupertinoAlertDialog(
              title: const Text("Phone Authentication"),
              content: const Text("Phone Number verified!!!"),
              actions: [
                CupertinoButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            print(e.message);
          }
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }
}
