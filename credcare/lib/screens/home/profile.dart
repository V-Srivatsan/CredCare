import 'package:credcare/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:credcare/widgets/screen.dart' as screen;

import 'logic.dart' as logic;
import 'package:credcare/screens/auth/main.dart' as auth;

class Profile extends StatelessWidget {
  final Map<String, dynamic> profile;
  const Profile(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    return screen.Screen(
      appBar: AppBar(title: Text("Profile")),
      child: Column(
        mainAxisSize: .min, crossAxisAlignment: .stretch, spacing: 15,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(mainAxisSize: .min, spacing: 10, children: [
              Input(label: 'Phone', name: 'phone', disabled: true, value: profile["phone"], fill: Color(0xFFF5F5F5)),
              Input(label: 'Name', name: 'name', value: profile["name"], fill: Color(0xFFF5F5F5)),
              Input(label: 'Status', name: 'status', value: profile["is_verified"] ? "Verified" : "Not Verified", disabled: true, fill: Color(0xFFF5F5F5)),
              Input(label: "Role", name: "role", value: profile["is_head"] ? "Head" : "Member", disabled: true, fill: Color(0xFFF5F5F5),),
              Row(
                children: [
                  Flexible(child: Input(
                    label: 'Community', name:'community', disabled: true,
                    value: profile["community"] ?? "Not part of one", fill: Color(0xFFF5F5F5)
                  )),
                  IconButton(
                    onPressed: profile["community"] == null ? null : () async {
                      logic.leaveCommunity().then((_) {
                        Navigator.pop(context, true);
                      });
                    },
                    icon: Icon(Icons.logout)
                  )
                ]
              ),

            ]),
          ),

          ElevatedButton(
            onPressed: () {
              logic.logout().then((_) {
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (ctx) => auth.Screen()),
                  (_) => false
                );
              });
            }, child: Text("Logout"),
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
          )
        ],
      ),
    );
  }
}
