import 'dart:io';
import 'package:bazar/Services/service_video.dart';
import 'package:bazar/config/palette.dart';
import 'package:bazar/data/video.dart';
import 'package:bazar/widgets/circle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';
import 'package:expandable/expandable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:convert';

class BuyProcessOne extends StatefulWidget {
  const BuyProcessOne({Key? key}) : super(key: key);

  @override
  _BuyProcessOneState createState() => _BuyProcessOneState();
}

TextEditingController detailsController = TextEditingController();
TextEditingController textPriceController =
    TextEditingController(); // Input price
TextEditingController nbreController =
    TextEditingController(); // input quantity
String choiceStreet = "Shipping Address"; // string categoriex of product
String price = "";
String? details;
int NbrePiece = 01;
bool PopCatShow = false;
List<String> catList = <String>[];

List<String> pointlist = <String>[];

class _BuyProcessOneState extends State<BuyProcessOne> {
  String? _chosenValue;
  List<String> list = <String>[];
  getdata() async {
    await FirebaseFirestore.instance
        .collection("Categories_Produits")
        .doc('fN0wAauWilUfslhBQGA3')
        .get()
        .then((value) {
      setState(() {
        pointlist = List.from(value.data()!["List"]);
        print(pointlist.length);
      });
    });
  }

  @override
  void initState() {
    getdata();
    setState(() {
      PopCatShow = false;
      NbrePiece = 01;
      choiceStreet = "Shipping Address";
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.colorLight,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.colorLight,
        statusBarIconBrightness: Brightness.light, // dark text for status bar
        statusBarColor: Palette.primaryColor));

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Pour empecher le debordemnent de la page a l'affiche du cla
      backgroundColor: Palette.colorLight,
      body: Column(children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Container(
                  height: 40,
                  color: Palette.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: Palette.colorLight,
                            ),
                          ),
                          // onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                          child: Text(
                            'New order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Prompt_Bold',
                              color: Palette.colorLight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              // Details du produit
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          // height: 200,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Palette.colorInput,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(children: [
                            TextFormField(
                              controller: detailsController,
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
                              onChanged: (value) {
                                setState(() {
                                  details = detailsController.text;
                                });
                              },
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
                      // Prix et Nombre de piece

                      //  Prix du produit

                      //  Nombres de pieces du produits
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Palette.colorInput,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(children: [
                          // Bouton de soustraction
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
                          Spacer(),
                          // Nombre de pieces
                          GestureDetector(
                            onTap: () {
                              AddPopup(context);
                            },
                            child: Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    NbrePiece.toString(),
                                    style: TextStyle(
                                      color: Palette.colorText,
                                      fontSize: 20.0,
                                      fontFamily: 'Prompt_Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          // Boutton Pour ajoute
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
                      SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            PopCatShow = !PopCatShow;
                          });

                          PopupListCategoris();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          height: 50,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Palette.colorInput,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    choiceStreet,
                                    style: TextStyle(
                                      fontFamily: "Prompt_Regular",
                                      fontSize: 18,
                                      color: Palette.colorgray,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: (() => PopupListCategoris()),
                                    child: SvgPicture.asset('assets/plus.svg')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ]),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 30),
          height: 30,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total to pay',
                style: TextStyle(
                  color: Palette.secondColor,
                  fontFamily: "Prompt_Medium",
                  fontSize: 24,
                )),
            Row(
              children: [Text('2000'), Text('FCFA')],
            )
          ]),
        ),
        Container(
            color: details != "" && choiceStreet != "Categories"
                ? Palette.primaryColor
                : Palette.disable,
            width: MediaQuery.of(context).size.width,
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      details != "" && choiceStreet != "Categories"
                          ? uploadStorage()
                          : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Center(
                        child: Text(
                          'Pay now',
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
                  ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () {
                      uploadStorage();
                      print("lelocueh");
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset('assets/next.svg'),
                    ),
                    // onPressed: () {},
                  ),
                ),
              ],
            )),
      ]),
    );
  }

// Fonction d'ajout de la video sur firebase et d'ajout de la publication
  Future uploadStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('name');
    try {
      // await storage.ref('$user/$widget.path').putFile(
      //       File(widget.path),
      //     );
      // String downloadURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('$user/$widget.path')
      //     .getDownloadURL();

      var data = [
        {
          "numeroVendeur": '$prefs.getString("number")',
          "prix": price,
          "nom": "$prefs.getString('name')",
          "video_title": "video_title",
          "Category": choiceStreet,
          "likes": 0,
          "details": details!,
          "profile": '$prefs.getString("photo")',
          "quantite": nbreController.text,
          "url": "downloadURL",
          "username": "cabraule"
        }
      ];
      await FirebaseFirestore.instance.collection("Videos").add(data.first);
    } catch (e) {
      print(e);
    }
  }

  // Popup dajout de quantite

  void AddPopup(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Palette.colorInput,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: nbreController,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: Palette.colorText,
                                fontFamily: "Prompt_Regular",
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 22),
                            onChanged: (value) {
                              NbrePiece = int.parse(nbreController.text);
                            },
                            decoration: new InputDecoration.collapsed(
                              hintText: 'Enter quantity in stock',
                              hintStyle: TextStyle(
                                fontFamily: "Prompt_Regular",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: InkWell(
                          onTap: () async {
                            // Allez a l'onglet 2
                            FocusScope.of(context).unfocus();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/expand.svg')),
                        ),
                      ),
                      // onPressed: () {},
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }

// Popup List categories
  void PopupListCategoris() async {
    //  Cat();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              height: MediaQuery.of(context).size.height * 2,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: Palette.primaryColor,
                  ),
                  Container(
                    height: 50,
                    color: Palette.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Palette.colorLight,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  'Shipping address',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'Prompt_Bold',
                                    color: Palette.colorLight,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: pointlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print(pointlist.length);
                          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                choiceStreet = pointlist[index];
                                print(choiceStreet);
                                Navigator.of(context).pop(); // Close popup
                              });
                            }),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Palette.colorInput,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(pointlist[index],
                                    style: TextStyle(
                                        fontFamily: "Prompt_Medium",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Palette.colorText)),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
