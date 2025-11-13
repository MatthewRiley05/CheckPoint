import 'package:flutter/material.dart';

class EventInput extends StatelessWidget {
  final TextEditingController controller;

  const EventInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Event Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Event name cannot be empty';
        }
        return null;
      },
    );
  }
}
