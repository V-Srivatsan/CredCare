import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Input extends StatelessWidget {
  final String label, name, error;
  final String? value;
  final bool disabled, multiline; final TextInputType type;
  final Color fill;

  const Input({
    super.key, required this.label, required this.name,
    this.error = "", this.disabled = false, this.value = null,
    this.fill = Colors.white, this.multiline = false,
    this.type = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      keyboardType: type, name: name,
      enabled: !disabled, initialValue: value,
      minLines: multiline ? 3 : 1, maxLines: multiline ? 8 : 1,
      decoration: InputDecoration(
        filled: true, labelText: label, fillColor: fill,
      )
    );
  }
}
