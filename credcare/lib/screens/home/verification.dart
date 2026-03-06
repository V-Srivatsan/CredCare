import 'package:flutter/material.dart';
import 'package:credcare/widgets/screen.dart' as screen;
import 'package:intl/intl.dart';
import 'logic.dart' as logic;

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  List<dynamic> users = [];

  void getRequests() async {
    final res = await logic.getCommunityRequests();
    if (mounted && res.success) setState(() { users = res.data["requests"]; });
  }

  void approve(BuildContext ctx, String uid) async {
    final res = await logic.approve(uid);
    if (res.success) {
      final updated = users.where((user) => user["uid"] != uid).toList();
      if (mounted) setState(() { users = updated; });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data["detail"]["message"])));
    }
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return screen.Screen(
      scrollable: false,
      appBar: AppBar(title: Text("User Verification")),
      child: ListView(
        children: users.map((user) => InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 5),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Flexible(child: Column(
                      mainAxisSize: .min, crossAxisAlignment: .stretch,
                      children: [
                        Text(user["user"], style: Theme.of(context).textTheme.titleLarge),
                        Text(user["phone"]),
                      ],
                    )),

                    Text("Joined ${DateFormat('dd/MM/yy').format(DateTime.parse(user['created_at']))}")
                  ]),
                  ElevatedButton(onPressed: () => approve(context, user["uid"]), child: Text("Verify"))
                ],
              ),
            ),
          )
        )).toList(),
      ),
    );
  }
}
