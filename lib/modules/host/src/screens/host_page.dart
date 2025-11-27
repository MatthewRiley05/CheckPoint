import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
  String _qrToken = '';
  int _qrExpiry = 60;
  Timer? _qrTimer;

  final String apiBaseUrl = 'http://10.0.2.2:3000'; // For emulator

  @override
  void initState() {
    super.initState();
    eventController.addListener(_validateForm);
  }

  @override
  void dispose() {
    eventController.removeListener(_validateForm);
    eventController.dispose();
    _qrTimer?.cancel();
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

  Future<void> _createEvent() async {
    final eventName = eventController.text.trim();
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'eventName': eventName}),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isEventCreated = true;
          _qrToken = data['qrToken'];
          _qrExpiry = data['qrTokenExpiry'] ?? 60;
        });

        // Start QR rotation timer
        //_qrTimer = Timer.periodic(Duration(seconds: _qrExpiry), (_) => _refreshQr(data['hostToken']));
      } else {
        _showError('Failed to create event: ${response.body}');
      }
    } catch (e) {
      _showError('Error creating event: $e');
    }
  }

  Future<void> _refreshQr(String hostToken) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/sessions/$hostToken/qr'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _qrToken = data['qrToken'];
        });
      }
    } catch (e) {
      print('QR Refresh Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
              QrCodeDisplay(eventData: _qrToken, isVisible: _isEventCreated),
              AttendanceTable(attendanceData: const []),
            ],
          ),
        ),
      ),
    );
  }
}
