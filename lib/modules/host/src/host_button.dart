import 'package:flutter/material.dart';

class HostButton extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback? onPressed;
  const HostButton({super.key, required this.isFormValid, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isFormValid ? onPressed : null,
      icon: const Icon(Icons.event),
      label: const Text('Create Event'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
