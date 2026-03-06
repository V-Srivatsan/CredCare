import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final Widget child; final AppBar? appBar; final FloatingActionButton? fab;
  final bool scrollable;

  const Screen({super.key, this.appBar = null, required this.child, this.fab = null, this.scrollable = true });

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: child,
    );

    return Scaffold(
      appBar: appBar, floatingActionButton: fab,
      body: SafeArea(
          child: scrollable ? SingleChildScrollView(child: body) : body
      ),
    );
  }
}
