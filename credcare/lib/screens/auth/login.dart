import 'package:flutter/material.dart';
import 'package:credcare/widgets/input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'logic.dart' as logic;

import 'package:credcare/screens/home/main.dart' as home;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormBuilderState>();

  bool loading = false, otp = false;
  String? error = null;

  void goToHome(BuildContext ctx) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(
        builder: (context) => home.Screen()
    ));
  }

  void login() async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; error = null; });

    final res = await logic.login(_key.currentState!.value["phone"]);

    if (!res.success) {
      print(res.data);
      setState(() { error = res.data["detail"]["message"]; });
    } else {
      print(res.data);
      setState(() { error = null; otp = true; });
    }

    setState(() { loading = false; });
  }

  void verify(BuildContext ctx) async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; error = null; });

    final data = _key.currentState!.value;
    final res = await logic.verifyOTP(data["phone"], data["otp"]);

    if (!res.success) {
      print(res.data);
      setState(() { error = res.data["detail"]["message"]; });
    } else
      goToHome(ctx);

    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    logic.isLogged().then((logged) { if (logged) goToHome(context); });

    return FormBuilder(
      key: _key, autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min, spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Input(
            label: "Phone number", name: "phone",
            type: TextInputType.phone, disabled: otp,
          ),

          (otp ? Input(
            label: "OTP", name: "otp",
            type: TextInputType.number,
          ) : SizedBox()),

          (error != null ? Text(
            error!, textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),

          ) : SizedBox()),
          
          (!otp ? SizedBox() :
            TextButton(onPressed: login, child: Text("Resend OTP"))
          ),

          ElevatedButton(
            onPressed: loading ? null : (otp ? () => verify(context) : login),
            child: Text(otp ? "Verify OTP" : "Login")
          )
        ],
      )
    );
  }
}
