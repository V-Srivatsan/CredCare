import 'package:flutter/material.dart';
import 'package:credcare/widgets/screen.dart' as screen;
import 'package:credcare/widgets/loader.dart';
import 'logic.dart' as logic;

class JoinCommunity extends StatefulWidget {
  const JoinCommunity({super.key});

  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {

  List<dynamic> communities = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    logic.getCommunities().then((res) {
      if (mounted) {
        setState(() { loading = false; });
        if (res.success)
          setState(() { communities = res.data['communities']; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return screen.Screen(
      scrollable: false,
      appBar: AppBar(title: Text("Join Community")),
      child: Loader(loading: loading, child: ListView(
        children: communities.map((community) =>
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 7.5),
            child: ListTile(
              title: Row(spacing: 5, children: [
                Text(community["name"]),
                Icon(Icons.verified, color: community["is_verified"] ? Colors.blue : Colors.grey)
              ]),
              subtitle: Text("${community['member_count']} ${community['member_count'] > 1 ? 'members' : 'member'}"),

              trailing: IconButton(onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Join ${community['name']}?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () { Navigator.pop(ctx); }, child: Text("Cancel"),
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red))
                      ),
                      
                      ElevatedButton(onPressed: () {
                        logic.joinCommunity(community["uid"]).then((res) {
                          Navigator.pop(ctx);
                          if (!res.success)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data["detail"]["message"])));
                          else
                            Navigator.pop(context, true);
                        });
                      }, child: Text("Join"))
                    ],
                  )
                );
              }, icon: Icon(Icons.login)),
            )
          )
        ).toList(),
      )),
    );
  }
}
