import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  final String msg;
  final double size;
  final Color color;
  final FontWeight weight;
  final green;
  int Nprod ;

  CustomText({this.size,@required this.msg, this.color, this.weight, this.green});

  @override
  Widget build(BuildContext context) {
    return Text(msg, style: TextStyle(fontSize: size ?? 18, color: color ?? Colors.black, fontWeight: weight ?? FontWeight.normal));
  }
}