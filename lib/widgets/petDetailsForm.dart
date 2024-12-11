import 'package:flutter/material.dart';

class PetDetailsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String, String, String, String) onSave;

  const PetDetailsForm({
    Key? key,
    required this.formKey,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Pet Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter pet name' : null,
              onSaved: (value) => onSave(value!, '', '', ''),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Pet Type'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter pet type' : null,
              onSaved: (value) => onSave('', value!, '', ''),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Pet Age'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter pet age' : null,
              onSaved: (value) => onSave('', '', value!, ''),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              validator: (value) => value?.isEmpty ?? true ? 'Enter price' : null,
              onSaved: (value) => onSave('', '', '', value!),
            ),
          ],
        ),
      ),
    );
  }
}
