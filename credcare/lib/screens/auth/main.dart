import 'package:flutter/material.dart';
import 'package:credcare/widgets/screen.dart' as screen;
import 'register.dart';
import 'login.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    return screen.Screen(
      scrollable: false,
      child: Center(child: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage("assets/credcare.png"), height: 100, width: 100),
            Text("Welcome to CredCare", style: Theme.of(context).textTheme.titleLarge),
            const Text("Connect with your community"),

            SizedBox(height: 50),

            (!_isRegister ? Login() :
              Register(() { setState(() { _isRegister = false; }); })
            ),

            TextButton(
              onPressed: () { setState(() { _isRegister = !_isRegister; }); },
              child: (_isRegister ?
                const Text("Already have an account? Login") :
                const Text("Don't have an account? Signup")
              )
            )
          ]
        ))
      ),
    );
  }
}