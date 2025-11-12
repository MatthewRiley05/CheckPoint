import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  final TextEditingController controller;

  const NameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
      ),
    );
  }
}
