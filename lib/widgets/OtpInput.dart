import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final Function onChanged;
  const OtpInput(this.controller, this.autoFocus, this.onChanged, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        style: TextStyle(
          fontFamily: "Prompt_Regular",
          fontSize: 16,
          color: Palette.colorText,
        ),
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Palette.colorInput,
            filled: true,
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          onChanged(value);
          // if (value.length == 1) {
          //   FocusScope.of(context).nextFocus();
          // }
          // if (value.length == 0 || value.length == null) {
          //   FocusScope.of(context).previousFocus();
          // }
        },
      ),
    );
  }
}
