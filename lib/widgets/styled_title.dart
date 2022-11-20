import 'package:flutter/material.dart';

class StyledTitle extends StatelessWidget {
  const StyledTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'REGISTER',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0XFF0071BC),
          ),
        ),
        Text(
          'A New Complain',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0XFF0071BC),
          ),
        ),
      ],
    );
  }
}
