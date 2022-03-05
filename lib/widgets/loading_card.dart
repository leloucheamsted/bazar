import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.white,
                Colors.white,
                Colors.grey,
                //add more colors for gradient
              ],
              begin: Alignment.topCenter, //begin of the gradient color
              end: Alignment.bottomCenter, //end of the gradient color
              stops: [0, 0.2, 0.5, 0.8] //stops for individual color
              //set the stops number equal to numbers of color
              ),
        ),
      ),
    );
  }
}
