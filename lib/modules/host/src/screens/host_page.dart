import 'package:checkpoint/modules/host/src/event_input.dart';
import 'package:checkpoint/modules/host/src/host_button.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final TextEditingController eventController = TextEditingController();
  bool _isFormValid = false;
  bool _isEventCreated = false;
  String? _eventData;

  @override
  void initState() {
    super.initState();
    eventController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = eventController.text.isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _createEvent() {
    setState(() {
      _isEventCreated = true;
      _eventData = eventController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              EventInput(controller: eventController),
              HostButton(isFormValid: _isFormValid, onPressed: _createEvent),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: _isEventCreated ? 400 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isEventCreated ? 1.0 : 0.0,
                  child: _isEventCreated
                      ? _buildQrCodeContainer()
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCodeContainer() {
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
              data: _eventData ?? '',
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
