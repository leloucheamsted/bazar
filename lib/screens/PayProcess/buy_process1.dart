import 'dart:io';
import 'dart:ui';
import 'package:bazar/Services/service_video.dart';
import 'package:bazar/config/palette.dart';
import 'package:bazar/data/video.dart';
import 'package:bazar/widgets/circle_button.dart';
import 'package:bazar/widgets/item_ville.dart';
import 'package:bazar/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class BuyProcessOne extends StatefulWidget {
  final Video video;
  const BuyProcessOne({required this.video, Key? key}) : super(key: key);

  @override
  _BuyProcessOneState createState() => _BuyProcessOneState();
}

TextEditingController detailsController = TextEditingController();
TextEditingController textPriceController =
    TextEditingController(); // Input price
TextEditingController nbreController =
    TextEditingController(); // input quantity
String choiceStreet = "Shipping Address"; // string categoriex of product
int price = 0;
String? details;
int NbrePiece = 01;
bool PopCatShow = false;

List<String> pointlist = <String>[];
String ville = "";

class _BuyProcessOneState extends State<BuyProcessOne> {
  String? _chosenValue;
  List<String> list = <String>[];
  getdata() async {
    await FirebaseFirestore.instance
        .collection("Ville")
        .doc('0JLnCiTjqF8ZcbOAs20E')
        .get()
        .then((value) {
      setState(() {
        pointlist = List.from(value.data()!["Liste_ville"]);
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
      price = int.parse(widget.video.prix) * NbrePiece;
      choiceStreet = "Shipping Address";
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.colorLight,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.colorLight,
        statusBarIconBrightness: Brightness.light, // dark text for status bar
        statusBarColor: Palette.primaryColor));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.colorLight,
      body: Stack(
        children: [
          Column(children: [
            Topbar(title: 'New order', onpressed: () {}),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // DETAILS
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.video.details,
                            style: TextStyle(
                                color: Palette.colorText,
                                fontFamily: "Prompt_Regular",
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),

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
                                price =
                                    int.parse(widget.video.prix) * NbrePiece;
                              });
                            }
                          },
                          child: Icon(
                            Icons.horizontal_rule,
                            size: 20,
                          ),
                        ),

                        //     // Nombre de pieces
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            AddPopup(context);
                          },
                          child: Expanded(
                            child: Container(
                              color: Palette.colorInput,
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
                        //     // Boutton Pour ajoute
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              NbrePiece += 1;
                              price = int.parse(widget.video.prix) * NbrePiece;
                            });
                          },
                          child: Icon(Icons.add),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Delivery address',
                        style: TextStyle(
                            fontFamily: "Prompt_Medium",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Palette.colorText),
                      ),
                    ),

                    SizedBox(
                      height: 5,
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
                                    color: choiceStreet == "Shipping Address"
                                        ? Palette.colorgray
                                        : Palette.colorText,
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Choose payment method',
                        style: TextStyle(
                            fontFamily: "Prompt_Medium",
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Palette.colorText),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(5),
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Palette.colorText,
                          ),
                          child: Image.asset(
                            'assets/orange.png',
                            height: 10,
                            width: 10,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(5),
                            foregroundDecoration: BoxDecoration(
                              color: Colors.grey,
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(254, 202, 24, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/mtn.png',
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    // // // Number
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Palette.colorInput,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: 40),
                        keyboardType: TextInputType.number,
                        // onChanged: _onChanged,
                        // controller: pseudocontroller,
                        autocorrect: false,

                        textAlign: TextAlign.start,
                        validator: (value) {
                          if (value == "base" || value == "basic") {
                            return "Username  not valid";
                          }
                        },
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Prompt_Regular',
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Phone number',
                          hintStyle: TextStyle(color: Palette.secondColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: Palette.colorPayBar,
                    height: 60,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total to pay',
                              style: TextStyle(
                                color: Palette.secondColor,
                                fontFamily: "Prompt_Medium",
                                fontSize: 24,
                              )),
                          Row(
                            children: [
                              //  Prix du peoduits
                              Text(
                                price.toString(),
                                style: TextStyle(
                                  fontFamily: "Prompt_SemiBold",
                                  fontWeight: FontWeight.w600,
                                  color: Palette.colorText,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'FCFA',
                                style: TextStyle(
                                  fontFamily: "Prompt_SemiBold",
                                  fontWeight: FontWeight.w600,
                                  color: Palette.colorLight,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Container(
                      color: details != "" && choiceStreet != "Shipping Address"
                          ? Palette.primaryColor
                          : Palette.disable,
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                details != "" &&
                                        choiceStreet != "Shipping Address"
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
                                details != "" &&
                                        choiceStreet != "Shipping Address"
                                    ? uploadStorage()
                                    : null;
                                print("lelocueh");
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 10, 15, 15),
                                child: SvgPicture.asset('assets/next.svg'),
                              ),
                              // onPressed: () {},
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )
        ],
      ),
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
    FocusScopeNode currentFocus = FocusScope.of(context);

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
                              setState(() {
                                NbrePiece = int.parse(nbreController.text);
                                price =
                                    NbrePiece * int.parse(widget.video.prix);
                              });
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
                            setState(() {
                              NbrePiece = int.parse(nbreController.text);
                              price = NbrePiece * int.parse(widget.video.prix);
                            });
                            // Allez a l'onglet 2
                            Navigator.of(context).pop();
                            currentFocus.unfocus();
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
                    alignment: Alignment.bottomCenter,
                    height: 80,
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                    height: 20,
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
                            child: ItemVille(
                                ville: pointlist[index],
                                Pop: PopupListCategoris),
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
