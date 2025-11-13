import 'package:checkpoint/modules/host/src/attendance_table.dart';
import 'package:checkpoint/modules/host/src/event_input.dart';
import 'package:checkpoint/modules/host/src/host_button.dart';
import 'package:checkpoint/modules/host/src/qr_code_display.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    eventController.removeListener(_validateForm);
    eventController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = eventController.text.trim().isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _createEvent() {
    setState(() {
      _isEventCreated = true;
      _eventData = eventController.text.trim();
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
              QrCodeDisplay(
                eventData: _eventData ?? '',
                isVisible: _isEventCreated,
              ),
              AttendanceTable(attendanceData: const []),
            ],
          ),
        ),
      ),
    );
  }
}
