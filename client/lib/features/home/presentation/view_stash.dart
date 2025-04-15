import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewStash extends StatefulWidget {
  final String title;
  const ViewStash({super.key, required this.title});

  @override
  State<ViewStash> createState() => _ViewStashState();
}

class _ViewStashState extends State<ViewStash> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
