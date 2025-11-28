import 'package:checkpoint/modules/student/src/name_input.dart';
import 'package:checkpoint/modules/student/src/qr_scanner_button.dart';
import 'package:checkpoint/modules/student/src/student_id_input.dart';
import 'package:checkpoint/modules/student/src/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  final String apiBaseUrl = dotenv.get('API_BASE_URL', fallback: 'http://127.0.0.1:3000');

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateForm);
    studentIdController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        nameController.text.isNotEmpty && studentIdController.text.isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _openScanner() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (result != null && mounted) {
      try {
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/check-in'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'qrToken': result,
            'studentId': studentIdController.text,
            'studentName': nameController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data['message']} for ${data['eventName']}')),
          );
        } else {
          final errorData = json.decode(response.body);
          final error = errorData['error'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Check-in failed: $error')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during check-in: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_validateForm);
    studentIdController.removeListener(_validateForm);
    nameController.dispose();
    studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                NameInput(controller: nameController),
                StudentIdInput(controller: studentIdController),
                QRScannerButton(
                  openScanner: _openScanner,
                  isFormValid: _isFormValid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}