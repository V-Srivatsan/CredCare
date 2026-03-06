import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:credcare/widgets/input.dart';

import 'logic.dart' as logic;

class Register extends StatefulWidget {
  final Function() switchLogin;
  const Register(this.switchLogin, {super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<FormBuilderState>();
  bool loading = false; String? error = null;

  void register() async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; error = null; });

    final data = _key.currentState!.value;
    final res = await logic.register(data["name"], data["phone"]);

    if (!res.success) {
      setState(() { error = res.data["detail"]["message"]; });
    } else {
      widget.switchLogin();
    }

    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(key: _key, child: Column(
      mainAxisSize: MainAxisSize.min, spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(label: "Full Name", name: "name"),
        Input(label: "Phone number", name: "phone", type: TextInputType.phone),

        (error != null ? Text(
          error!, textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),

        ) : SizedBox()),

        ElevatedButton(onPressed: loading ? null : register, child: Text("Register"))
      ],
    ));
  }
}
