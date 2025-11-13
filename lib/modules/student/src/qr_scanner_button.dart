import 'package:flutter/material.dart';

class QRScannerButton extends StatelessWidget {
  final VoidCallback openScanner;
  final bool isFormValid;

  const QRScannerButton({
    super.key,
    required this.openScanner,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isFormValid ? openScanner : null,
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Scan QR Code'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
