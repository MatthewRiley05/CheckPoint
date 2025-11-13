import 'package:checkpoint/modules/student/src/name_input.dart';
import 'package:checkpoint/modules/student/src/qr_scanner_button.dart';
import 'package:checkpoint/modules/student/src/student_id_input.dart';
import 'package:checkpoint/modules/student/src/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scanned: $result')));
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
