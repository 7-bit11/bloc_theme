import 'package:bloc_demo/test.dart';
import 'package:bloc_demo/theme.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Scaffold(
        appBar: AppBar(
          title: const Text("其他页面"),
          backgroundColor: myColors.brandColor,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: myColors.danger),
            onPressed: () {
              //切换
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ThemeSwitch()));
            }));
  }
}
