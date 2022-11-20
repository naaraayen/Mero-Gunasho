import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatefulWidget {
  String? onSelected;
  final String hintText;
  final List<String> menuItems;
  CustomDropDown(this.onSelected, this.hintText, this.menuItems, {super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.black26, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: widget.onSelected,
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            hint: Text(widget.hintText),
            items: widget.menuItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  widget.onSelected = value;
                });
              }
            }),
      ),
    );
  }
}
