import 'package:calender_tool/database/database_service.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Drawer')),
          ListTile(title: Text('Setting')),
          TextButton(
            onPressed: () => DatabaseService.instance.clearTable(),
            child: Text('Clear database', textAlign: TextAlign.start),
          ),
          TextButton(
            onPressed: () => DatabaseService.instance.recreateTable(),
            child: Text('Drop database', textAlign: TextAlign.start),
          ),
          TextButton(
            onPressed: () => DatabaseService.instance.viewAllRows(),
            child: Text('View all rows', textAlign: TextAlign.start),
          ),
        ],
      ),
    );
  }
}
