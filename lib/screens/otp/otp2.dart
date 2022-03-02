import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../config/palette.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../screens.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  String phone = "+237" + Get.arguments.text.toString();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    //color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
    print(phone);
  }

  @override
  Widget build(BuildContext context) {
    // String number = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleButton(
                    icon: Icons.arrow_back_outlined,
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      'basic',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Prompt_Bold',
                        color: Palette.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '4-digit code',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Prompt_Bold',
                  color: Palette.colorText,
                ),
              ),
              Text(
                'Please enter the code we’ve sent by SMS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Prompt_Regular',
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                focusNode: _pinPutFocusNode,
                animationDuration: Duration(milliseconds: 10),
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
                        SetupAccountScreen(),
                        arguments: phone,
                        transition: Transition.rightToLeft,
                        duration: Duration(seconds: 1),
                      );
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState!
                        .showSnackBar(SnackBar(content: Text('invalid OTP')));
                  }
                },
              ),
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
              title: Text("Phone Authentication"),
              content: Text("Phone Number verified!!!"),
              actions: [
                CupertinoButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
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
        timeout: Duration(seconds: 120));
  }
}
