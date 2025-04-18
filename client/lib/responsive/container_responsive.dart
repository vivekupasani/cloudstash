import 'package:flutter/material.dart';

class ContainerResponsive extends StatefulWidget {
  final AppBar? appBar;
  final Widget? body;
  final FloatingActionButton? floatingActionButton;
  const ContainerResponsive({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  @override
  State<ContainerResponsive> createState() => _ContainerResponsiveState();
}

class _ContainerResponsiveState extends State<ContainerResponsive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      appBar: widget.appBar,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: widget.body,
        ),
      ),
    );
  }
}
