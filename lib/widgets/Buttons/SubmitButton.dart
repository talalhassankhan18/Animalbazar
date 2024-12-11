import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),        ),
      margin: EdgeInsets.symmetric(vertical: 10),        child: ElevatedButton(
        onPressed: onSubmit,
        child: Text('Post Pet for Sale'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
