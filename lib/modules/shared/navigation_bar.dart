import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HostStudentNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const HostStudentNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Symbols.co_present_rounded, opticalSize: 40, weight: 700),
          label: 'Host',
        ),
        NavigationDestination(
          icon: Icon(Symbols.person_edit_rounded, opticalSize: 40, weight: 700),
          label: 'Student',
        ),
      ],
    );
  }
}
