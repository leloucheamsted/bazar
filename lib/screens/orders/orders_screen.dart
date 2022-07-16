import 'package:bazar/config/palette.dart';
import 'package:bazar/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrdersScreen extends StatefulWidget {
  final Function onClicked;
  const OrdersScreen({Key? key, required this.onClicked}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   backgroundColor: Palette.primaryColor,
      //   centerTitle: true,
      //   title: Text('New post'),
      // ),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Balance',
                    style: TextStyle(
                        fontFamily: "Prompt_SemiBold",
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Palette.colorText),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    // TOTAL BALANCE
                    Row(
                      children: const [
                        //  Prix du peoduits
                        Text(
                          '90,000',
                          style: TextStyle(
                            fontFamily: "Prompt_SemiBold",
                            fontWeight: FontWeight.w600,
                            color: Palette.colorText,
                            fontSize: 24,
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
                            color: Colors.grey,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    InkWell(
                      onTap: () {
                        setState(() {
                          //print("object");
                          widget.onClicked;
                        });
                        // Get.to(const Withdraw(),
                        //     transition:  Transition);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'withdraw',
                          style: TextStyle(
                              fontFamily: "Prompt_Medium",
                              fontWeight: FontWeight.w500,
                              color: Palette.primaryColor,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                        fontFamily: "Prompt_SemiBold",
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Palette.colorText),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
              child: Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 10),
                      blurRadius: 10,
                      spreadRadius: 10)
                ]),
                child: MediaQuery.removeViewPadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    shrinkWrap: true,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const OrderItem(),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  void Popwidraw(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          child: const TextField(
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search for an item …',
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
                            Navigator.of(context).pop();
                            // Allez a l'onglet 2

                            FocusScope.of(context).unfocus();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/search.svg')),
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
}
