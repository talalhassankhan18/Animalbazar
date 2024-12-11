import 'package:flutter/material.dart';

class PetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumeric;

  const PetInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.isNumeric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}