import 'package:checkpoint/modules/shared/navigation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const CheckPoint());
}

class CheckPoint extends StatelessWidget {
  const CheckPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckPoint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const NavigationScaffold(),
    );
  }
}
