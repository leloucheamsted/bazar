import 'package:bazar/config/palette.dart';
import 'package:bazar/screens/otp/otp2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EnterNumberScreen extends StatefulWidget {
  const EnterNumberScreen({Key? key}) : super(key: key);

  @override
  _EnterNumberScreenState createState() => _EnterNumberScreenState();
}

class _EnterNumberScreenState extends State<EnterNumberScreen> {
  TextEditingController textController = TextEditingController();
  int length = 0;
  RegExp digitValidator = RegExp("[0-9]+");
  bool status = false;

// Lorsque le texte change
  _onChanged(String value) {
    setState(() {
      length = value.length;
      if (length == 9) {
        status = true;
      } else {
        status = false;
      }
    });
  }

  // desactiver le boutton
  disableButton() {
    setState(() {
      status = false;
    });
  }

  //activer le bouton
  enableButton() {
    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50.0, 20.0, 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'basic',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'Prompt_Bold',
                  color: Palette.primaryColor,
                ),
              ),
              Text(
                'Phone number',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Prompt_Bold',
                  color: Palette.colorText,
                ),
              ),
              Text(
                'Enter your phone number to get started',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Prompt_Regular',
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 45,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Palette.colorgray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/Cameroon.png',
                          ),
                          ImageIcon(
                            AssetImage(
                              'assets/drop.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Palette.colorgray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: textController,
                        autofocus: false,
                        inputFormatters: <TextInputFormatter>[
                          // PhoneNumberFormatter(),
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.allow(RegExp(
                            "[^,.-]",
                          )),
                        ],
                        onChanged: _onChanged,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Regular',
                        ),
                        decoration: InputDecoration.collapsed(
                            hintText: '6 80 80 80 80'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Palette.primaryColor,
                  disabledColor: Palette.disableButton,
                  disabledTextColor: Palette.colorLight,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Prompt_Medium',
                    ),
                  ),
                  onPressed: status
                      ? () {
                          Get.to(
                            EnterCodeScreen(),
                            arguments: textController,
                            transition: Transition.rightToLeft,
                            duration: Duration(seconds: 1),
                          );
                        }
                      : null,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'By using the app you agree to bazar’s privacy policy and terms and conditions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.colorText,
                  fontSize: 20,
                  fontFamily: 'Prompt_Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (newText.length == 1) newText = newText + '';
    if (newText.length == 4) newText = newText + ' ';
    if (newText.length == 7) newText = newText + ' ';
    if (newText.length == 10) newText = newText + ' ';

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
