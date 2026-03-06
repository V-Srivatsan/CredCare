import 'package:flutter/material.dart';
import 'community_setup/new_community.dart';
import 'community_setup/join_community.dart';

class CommunitySetup extends StatelessWidget {
  final Function() refresh;
  const CommunitySetup(this.refresh, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        CardButton(
            icon: Icons.add, title: "Create Community",
            desc: "Start a new community for your society",
            onTap: () async {
              final created = await showModalBottomSheet(
                context: context,
                builder: (ctx) => NewCommunity()
              );

              if (created == true) refresh();
            }
        ),
        CardButton(
            icon: Icons.people_alt_outlined, title: 'Join Community',
            desc: "Browse and join communities",
            onTap: () async {
              final joined = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => JoinCommunity()));
              if (joined == true) refresh();
            }
        )
      ],
    );
  }
}

class CardButton extends StatelessWidget {
  final String title, desc;
  final Function() onTap;
  final IconData icon;
  const CardButton({
    super.key, required this.icon,
    required this.title, required this.desc, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, border: BoxBorder.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            Flexible(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(desc)
              ],
            )),
            Icon(icon)
          ],
        ),
      ),
    );
  }
}

