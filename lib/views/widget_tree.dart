import 'package:calender_tool/data/notifiers.dart';
import 'package:calender_tool/views/pages/calender_page.dart';
import 'package:calender_tool/views/pages/friend_page.dart';
import 'package:calender_tool/views/widgets/custom_drawer.dart';
import 'package:calender_tool/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [CalenderPage(), FriendPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Tools'),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectPageNotifier,
        builder: (context, pageIndex, child) {
          return pages.elementAt(pageIndex);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
