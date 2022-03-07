import 'dart:ffi';

import 'package:bazar/config/palette.dart';
import 'package:bazar/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:expandable/expandable.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({Key? key}) : super(key: key);
  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

final List<String> Categories = <String>[];
bool? isExpand;
TextEditingController textPriceController = TextEditingController();
TextEditingController nbreController = TextEditingController();

class DataList {
  DataList(this.title, [this.children = const <String>[]]);

  final String title;
  final List<String> children;
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  String? _chosenValue;
  int NbrePiece = 01;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.primaryColor,
        statusBarIconBrightness: Brightness.dark, // dark text for status bar
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Palette.colorLight,
      body: Stack(children: [
        Positioned(
          bottom: 0.0,
          child: Container(
              color: Palette.primaryColor,
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Next',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontFamily: "Prompt_Regular",
                          color: Palette.colorLight,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Palette.colorText,
                        ),
                      ),
                      // onPressed: () {},
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                        child: Text(
                          'Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Prompt_Bold',
                            color: Palette.colorText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 150,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    // height: 200,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Palette.colorgray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(children: [
                      TextFormField(
                        ///  controller: _controller,
                        //  focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        style: TextStyle(
                            color: Palette.colorText,
                            fontFamily: "Prompt_Regular",
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 22),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Détails de l'article",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Prompt_Regular",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 22),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),

                //  DropDownList(),

                /// List de categories
                ExpandableNotifier(
                  // <-- Provides ExpandableController to its children
                  child: Column(
                    children: [
                      Expandable(
                        // <-- Driven by ExpandableController from ExpandableNotifier
                        collapsed: ExpandableButton(
                          // <-- Expands when tapped on the cover photo
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Palette.colorgray,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontFamily: "Prompt_Regular",
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset('assets/drop.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        expanded: Column(children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            height: 200,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Palette.colorgray,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          ExpandableButton(
                            // <-- Collapses when tapped on
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.expand_less_sharp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 12,
                ),

                // Prix et Nombre de piece
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 50,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Palette.colorgray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                                child: TextField(
                                  // controller: textController,
                                  autofocus: false,
                                  inputFormatters: <TextInputFormatter>[
                                    // PhoneNumberFormatter(),
                                    LengthLimitingTextInputFormatter(9),
                                    FilteringTextInputFormatter.allow(RegExp(
                                      "[^,.-]",
                                    )),
                                  ],
                                  //onChanged: _onChanged,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Prompt_Regular',
                                  ),
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: 'Item price'),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'FCFA',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Prompt_Regular",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Palette.colorgray,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            if (NbrePiece == 1) {
                            } else {
                              setState(() {
                                NbrePiece -= 1;
                              });
                            }
                          },
                          child: Icon(
                            Icons.horizontal_rule,
                            size: 20,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 40,
                          child: Center(
                            child: TextField(
                              controller: nbreController
                                ..text = NbrePiece.toString(),

                              autofocus: false,
                              inputFormatters: <TextInputFormatter>[
                                // PhoneNumberFormatter(),
                                // LengthLimitingTextInputFormatter(9),
                                FilteringTextInputFormatter.allow(RegExp(
                                  "[^,.-]",
                                )),
                              ],
                              //onChanged: _onChanged,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Palette.colorText,
                                fontSize: 20.0,
                                fontFamily: 'Prompt_Regular',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // labelText: '01',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              NbrePiece += 1;
                            });
                          },
                          child: Icon(Icons.add),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 13,
          right: 8,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset('assets/next.svg'),
            ),
            // onPressed: () {},
          ),
        ),
      ]),
    );
  }

  Widget DropDownList() {
    return DropdownButton<String>(
      focusColor: Colors.white,
      value: _chosenValue,
      //elevation: 5,
      style: TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: <String>[
        'Android',
        'IOS',
        'Flutter',
        'Node',
        'Java',
        'Python',
        'PHP',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Text(
        "Please choose a langauage",
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value;
        });
      },
    );
  }
}
