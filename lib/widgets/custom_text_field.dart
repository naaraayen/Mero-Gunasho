import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.focusNode,
    this.controller,
    required this.validator,
    required this.onSaved,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        focusNode: focusNode,
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
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
