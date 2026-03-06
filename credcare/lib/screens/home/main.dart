import 'package:credcare/screens/home/requests/main.dart';
import 'package:credcare/screens/home/requests/new_request.dart';
import 'package:flutter/material.dart';
import 'package:credcare/widgets/screen.dart' as screen;
import 'package:credcare/widgets/loader.dart';

import 'community_setup.dart';
import 'verification.dart';
import 'profile.dart';
import 'logic.dart' as logic;
import 'package:credcare/screens/auth/main.dart' as auth;


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  Map<String, dynamic>? profile = null;

  Future<void> getProfile() async {
    if (mounted) setState(() { profile = null; });
    final res = await logic.getProfile();
    if (mounted) setState(() { profile = res.data; });
  }


  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (profile?["community"] == null)
      return screen.Screen(
        scrollable: false,
        appBar: AppBar(
          title: Text("Welcome ${profile?["name"] ?? ''}"),
          actions: [
            IconButton(onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => Profile(profile ?? {})));
              if (res == true) getProfile();
            }, icon: Icon(Icons.person)
            )
          ],
        ),
        child: RefreshIndicator(
          onRefresh: this.getProfile,
          child: Loader(loading: profile == null, child: CommunitySetup(getProfile)),
        ),
      );

  if (profile?["is_verified"] != true)
    return screen.Screen(
      scrollable: false,
      appBar: AppBar(
        title: Text("Welcome ${profile?["name"] ?? ''}"),
        actions: [
          IconButton(onPressed: () async {
            final res = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => Profile(profile ?? {})));
            if (res == true) getProfile();
          }, icon: Icon(Icons.person)
          )
        ],
      ),
      child: RefreshIndicator(
        onRefresh: this.getProfile,
        child: Loader(loading: profile == null, child: Center(child: Text("You are not verified!"))),
      ),
    );

    return DefaultTabController(
      length: 3,
      child: screen.Screen(
        scrollable: false,
        appBar: AppBar(
          title: Text("Welcome ${profile!["name"]}"),
          bottom: TabBar(tabs: [
            Tab(text: "Pending"),
            Tab(text: "Created"),
            Tab(text: "Accepted")
          ]),
          actions: [

            ...(profile!["is_head"] == true ?
              [IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => Verification()));
              }, icon: Icon(Icons.verified_outlined))] :
              [SizedBox()]
            ),

            IconButton(onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => Profile(profile!)));
              if (res == true) getProfile();
            }, icon: Icon(Icons.person)
            )
          ],
        ),
        child: Requests(),
        fab: !profile!["is_verified"] ? null : FloatingActionButton(
          onPressed: () async {
            final created = await showModalBottomSheet(
                showDragHandle: true, isScrollControlled: true, context: context,
                builder: (ctx) => NewRequest()
            );

            if (created) setState(() {});
          },
          child: Icon(Icons.add),
        ),
      )
    );
  }
}