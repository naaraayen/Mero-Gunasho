import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  const CustomTextField(
      {super.key,
      required this.label,
      this.controller,
      required this.validator,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black26,
                    style: BorderStyle.solid,
                    width: 1.0))),
        controller: controller,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
