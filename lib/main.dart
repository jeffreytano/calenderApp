import 'package:calender_tool/views/widget_tree.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const StateLessApp());
}

class StateLessApp extends StatelessWidget {
  const StateLessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: WidgetTree(),
    );
  }
}
