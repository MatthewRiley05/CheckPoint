import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentIdInput extends StatelessWidget {
  final TextEditingController controller;

  const StudentIdInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Student ID',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }

          final lastChar = newValue.text[newValue.text.length - 1];

          if (RegExp(r'[a-zA-Z]').hasMatch(lastChar)) {
            final correctedText =
                newValue.text.substring(0, newValue.text.length - 1) +
                lastChar.toLowerCase();
            return TextEditingValue(
              text: correctedText,
              selection: TextSelection.collapsed(offset: correctedText.length),
            );
          }

          return newValue;
        }),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your student ID';
        }

        final RegExp studentIdPattern = RegExp(r'^\d+[a-z]$');

        if (!studentIdPattern.hasMatch(value)) {
          return 'Student ID must be numbers followed by a letter';
        }

        return null;
      },
    );
  }
}
