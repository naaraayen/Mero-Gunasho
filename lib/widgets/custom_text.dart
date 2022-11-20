import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String getText;
  final FontWeight? getWeight;
  final double fontSize;
  const CustomText(this.getText,
      {super.key, this.getWeight = FontWeight.bold, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        getText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: getWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
