import 'package:flutter/material.dart';

class ScaffoldResponsive extends StatelessWidget {
  final Widget? body;
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  const ScaffoldResponsive(
      {super.key,
      this.body,
      this.appBar,
      this.drawer,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: body,
        ),
      ),
    );
  }
}
