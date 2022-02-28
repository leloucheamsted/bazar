import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';

class EnterNumberScreen extends StatelessWidget {
  const EnterNumberScreen({Key? key}) : super(key: key);

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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
