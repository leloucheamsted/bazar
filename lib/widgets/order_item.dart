import 'package:bazar/config/palette.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              // NUMBER OF TRANSATION AND DATE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                // NUMBER
                children: const [
                  Text(
                    'Order no 1236765989',
                    style: TextStyle(
                      fontFamily: "Prompt_Regular",
                      fontWeight: FontWeight.w400,
                      color: Palette.colorText,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  // DATE

                  Text(
                    '3,000 FCFA',
                    style: TextStyle(
                      fontFamily: "Prompt_Regular",
                      fontWeight: FontWeight.w400,
                      color: Palette.colorText,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),

              // TOTAL PRICE OF TRANSACTION AND STATUT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TOTAL PRICE
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      'March 12, 2022 12:12',
                      style: TextStyle(
                        fontFamily: "Prompt_Medium",
                        fontWeight: FontWeight.w500,
                        color: Palette.secondColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // STATUT
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromRGBO(255, 192, 67, 1),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                        fontFamily: "Prompt_Regular",
                        fontWeight: FontWeight.w400,
                        color: Palette.colorLight,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
