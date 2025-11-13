import 'package:flutter/material.dart';

class HostButton extends StatelessWidget {
  final bool isFormValid;
  const HostButton({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isFormValid ? () {} : null,
      icon: const Icon(Icons.event),
      label: const Text('Create Event'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
