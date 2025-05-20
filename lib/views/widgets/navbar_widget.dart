import 'package:calender_tool/data/notifiers.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'calender'),
            NavigationDestination(icon: Icon(Icons.person), label: 'friends'),
          ],
          onDestinationSelected: (int value) {
            selectPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
