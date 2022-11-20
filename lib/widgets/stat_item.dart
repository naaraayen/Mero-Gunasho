import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final int statData;
  final String statTitle;
  final Color panelColor;
  const StatItem(this.statData, this.statTitle, this.panelColor,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: panelColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statData.toString(),
            style: const TextStyle(
                color: Color(0XFFFFFFFF), fontWeight: FontWeight.bold, fontSize: 20),
          ),
          FittedBox(
            child: Text(
              statTitle,
              style: const TextStyle(
                  color: Color(0XFFFFFFFF), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
