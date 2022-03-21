import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text(
      'orders',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    )));
  }
}
