import 'package:checkpoint/modules/host/src/screens/host_page.dart';
import 'package:checkpoint/modules/shared/navigation_bar.dart';
import 'package:checkpoint/modules/student/src/screens/student_page.dart';
import 'package:flutter/material.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int currentPageIndex = 0;

  final List<Widget> _screens = [const HostPage(), const StudentPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CheckPoint')),
      body: _screens[currentPageIndex],
      bottomNavigationBar: HostStudentNavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
