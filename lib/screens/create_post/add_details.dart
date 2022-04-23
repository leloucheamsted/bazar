import 'dart:io';
import 'package:bazar/Services/service_video.dart';
import 'package:bazar/config/palette.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AddDetailsScreen extends StatefulWidget {
  final String path;
  const AddDetailsScreen({required this.path, Key? key}) : super(key: key);

  @override
  _AddDetailsScreenState createState() => _AddDetailsScreenState();
}

TextEditingController detailsController = TextEditingController();
TextEditingController textPriceController =
    TextEditingController(); // Input price
TextEditingController nbreController =
    TextEditingController(); // input quantity
String choiceCategory = "Categories"; // string categoriex of product
String price = "";
String? details;
// ignore: non_constant_identifier_names
int NbrePiece = 01;
// ignore: non_constant_identifier_names
bool PopCatShow = false;
List<String> catList = <String>[];
VideoService? service;

List<String> pointlist = <String>[];
final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  List<String> list = <String>[];
  getdata() async {
    await FirebaseFirestore.instance
        .collection("Categories_Produits")
        .doc('fN0wAauWilUfslhBQGA3')
        .get()
        .then((value) {
      setState(() {
        pointlist = List.from(value.data()!["List"]);
        if (kDebugMode) {
          print(pointlist.length);
        }
      });
    });
  }

  @override
  void initState() {
    service = VideoService();
    getdata();
    setState(() {
      PopCatShow = false;
      NbrePiece = 01;
      choiceCategory = "Category";
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Palette.colorLight,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Palette.colorLight,
        statusBarIconBrightness: Brightness.light, // dark text for status bar
        statusBarColor: Palette.primaryColor));

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              systemNavigationBarColor: Palette.primaryColor,
              systemNavigationBarDividerColor: Palette.primaryColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness:
                  Brightness.light, // dark text for status bar
              statusBarColor: Colors.transparent));
        }
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Palette.primaryColor,
          centerTitle: true,
          title: const Text(
            'Details',
            style: TextStyle(
              fontFamily: "Prompt_SemiBold",
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Palette.colorLight,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.colorLight,
        body: Stack(children: [
          Column(children: [
            SizedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  // Details du produit
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: SizedBox(
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
                            controller: detailsController,
                            //  focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            style: const TextStyle(
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
                            decoration: const InputDecoration(
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
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: GestureDetector(
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
                          color: Palette.colorgray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  choiceCategory,
                                  style: const TextStyle(
                                    fontFamily: "Prompt_Regular",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Palette.colorText,
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
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                              padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                              child: TextField(
                                controller: textPriceController,
                                autofocus: false,
                                inputFormatters: <TextInputFormatter>[
                                  // PhoneNumberFormatter(),
                                  LengthLimitingTextInputFormatter(9),
                                  FilteringTextInputFormatter.allow(RegExp(
                                    "[^,.-]",
                                  )),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    price = textPriceController.text;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Prompt_Regular',
                                ),
                                decoration: const InputDecoration.collapsed(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    hintText: 'Item price'),
                              ),
                            ),
                          ),
                          const Center(
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

                  // Prix et Nombre de piece

                  //  Prix du produit

                  //  Nombres de pieces du produits
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 50,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Palette.colorgray,
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
                          child: const Icon(
                            Icons.horizontal_rule,
                            size: 20,
                          ),
                        ),
                        const Spacer(),
                        // Nombre de pieces
                        GestureDetector(
                          onTap: () {
                            SearchPopup(context);
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Center(
                              child: Text(
                                NbrePiece.toString(),
                                style: const TextStyle(
                                  color: Palette.colorText,
                                  fontSize: 20.0,
                                  fontFamily: 'Prompt_Regular',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Boutton Pour ajoute
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              NbrePiece += 1;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ]),
                    ),
                  ),
                  const Text(
                    '*Tap to enter amount in stock manually',
                    style: TextStyle(
                        fontFamily: "Prompt_Regular",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Palette.secondColor),
                  ),
                ],
              ),
            ),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color:
                  details != "" && price != "" && choiceCategory != "Categories"
                      ? Palette.primaryColor
                      : Palette.disable,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        details != "" &&
                                price != "" &&
                                choiceCategory != "Categories"
                            ? saveData()
                            : null;
                      },
                      child: const Padding(
                        padding: const EdgeInsets.fromLTRB(35.0, 0, 0, 0),
                        child: Center(
                          child: Text(
                            'Publish',
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: InkWell(
                      onTap: () async {
                        details != "" &&
                                price != "" &&
                                choiceCategory != "Categories"
                            ? {saveData()}
                            : null;
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset('assets/next.svg'),
                      ),
                      // onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

// Fonction d'ajout de la video sur firebase et d'ajout de la publication
  Future uploadStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('name');
    var id = Uuid().v4();
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final dir = _appDocDir.path;
    final outPath = "$dir/$id.gif";
    await _flutterFFmpeg
        .execute('-i ${widget.path} -vf fps=5,scale=450:-1 -t 3 $outPath');
    try {
      await storage.ref('videos/lelouche').putFile(
            File(widget.path),
          );
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('videos/lelouche')
          .getDownloadURL();
      debugPrint(outPath);
      await storage.ref('Gif/lelouche').putFile(
            File(outPath),
          );
      String downloadGifURL = await firebase_storage.FirebaseStorage.instance
          .ref('Gif/lelouche')
          .getDownloadURL();
      var data = [
        {
          "numeroVendeur": '$prefs.getString("number")',
          "prix": price,
          "nom": "$prefs.getString('name')",
          "video_title": "video_title",
          "Category": choiceCategory,
          "likes": '0',
          "details": details!,
          "profile":
              'https://firebasestorage.googleapis.com/v0/b/basic-aede4.appspot.com/o/cabraule.jpg?alt=media&token=d43ea864-6f86-4b6f-b2cd-385ffb65b7b5',
          "quantite": NbrePiece.toString(),
          "url": downloadURL,
          "username": "cabraule",
          'gifUrl': downloadGifURL
        }
      ];
      await FirebaseFirestore.instance.collection("Videos").add(data.first);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc('lelouche')
          .update({
        'publication': FieldValue.arrayUnion([downloadGifURL])
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> saveData() async {
    Navigator.of(context)
        .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // behavior: SnackBarBehavior.floating,
      backgroundColor: Palette.primaryColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 0.0),
      duration: const Duration(seconds: 6),
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Publishing your video",
              style: TextStyle(
                  color: Palette.colorLight,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Prompt_Regular'),
            ),
            SvgPicture.asset(
              'assets/close.svg',
              color: Palette.colorLight,
            ),
          ],
        ),
      ),
    ));

    uploadStorage();
//  uploadStorage().whenComplete(() =>
//                                 Navigator.of(context)
//                     .popUntil(ModalRoute.withName(Navigator.defaultRouteName)));
  }

  //  Popup Search
  // ignore: non_constant_identifier_names
  void SearchPopup(context) {
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
                            color: Palette.colorgray,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            autofocus: true,
                            controller: nbreController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Enter quantity in stock',
                              hintStyle: TextStyle(
                                fontFamily: "Prompt_Regular",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                NbrePiece = int.parse(nbreController.text);
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();
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
                const SizedBox(height: 10),
              ],
            ),
          );
        });
  }

// Popup List categories
  // ignore: non_constant_identifier_names
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
                              child: const Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Palette.colorLight,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  'Choice Category',
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
                  const SizedBox(
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
                                choiceCategory = pointlist[index];
                                if (kDebugMode) {
                                  print(choiceCategory);
                                }
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
                                  color: Palette.colorgray,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(pointlist[index],
                                    style: const TextStyle(
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
