import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeDisplay extends StatelessWidget {
  final String eventData;
  final bool isVisible;

  const QrCodeDisplay({
    super.key,
    required this.eventData,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: isVisible ? 400 : 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isVisible ? 1.0 : 0.0,
        child: isVisible
            ? _buildQrCodeContainer(context)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildQrCodeContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Event QR Code', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: PrettyQrView.data(
              data: eventData,
              decoration: const PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
