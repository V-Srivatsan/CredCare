import 'package:flutter/material.dart';

class CustomSheet extends StatelessWidget {
  final Widget child;
  const CustomSheet(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(child: child),
    );
  }
}
