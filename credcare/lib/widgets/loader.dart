import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool loading;
  final Widget child;
  const Loader({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) : child;
  }
}
