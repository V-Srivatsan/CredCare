import 'package:credcare/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'logic.dart' as logic;

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  List<dynamic> pending = [], created = [], accepted = [];

  Future<void> getRequests() async {
    List<dynamic> np = (await logic.getPendingRequests()).data["requests"];
    List<dynamic> nc = (await logic.getCreatedRequests()).data["requests"];
    List<dynamic> na = (await logic.getAcceptedRequests()).data["requests"];

    if (mounted) setState(() {
      pending = np;
      created = nc;
      accepted = na;
    });
    print(np);
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      RefreshIndicator(onRefresh: getRequests, child: RequestList(pending)),
      RefreshIndicator(onRefresh: getRequests, child: RequestList(created)),
      RefreshIndicator(onRefresh: getRequests, child: RequestList(accepted))
    ]);
  }
}

class RequestList extends StatelessWidget {
  final List<dynamic> requests;
  RequestList(this.requests, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: requests.map((request) => RequestCard(
        uid: request['uid'],
        title: request["title"], desc: request["description"], creator: request["creator"] ?? "You",
        date: DateTime.parse(request["updated_at"]), is_creator: request["creator"] == null,
        status: request["status"] ?? "PENDING"
      )).toList(),
    );
  }
}


class RequestCard extends StatelessWidget {
  final String uid, title, desc, creator, status;
  final DateTime date; final bool is_creator;
  const RequestCard({
    super.key, required this.uid,
    required this.title, required this.desc, 
    required this.creator, required this.date,
    this.status = "PENDING", this.is_creator = false
  });

  void submit(BuildContext ctx, Function(String) adapter, String uid) async {
    final res = await adapter(uid);
    if (!res.success)
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(res.data["detail"]["message"])));
    else
      Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    
    final List<Widget> actions = [];
    if (is_creator) {
      if (status == "PENDING")
        actions.add(ElevatedButton(
          onPressed: () => submit(context, logic.cancelRequest, uid),
          child: Text("Cancel"),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
        ));
      else if (status == "ACCEPTED")
        actions.add(ElevatedButton(onPressed: () => submit(context, logic.completeRequest, uid), child: Text("Complete")));
    } else {
      if (status == "PENDING")
        actions.add(ElevatedButton(onPressed: () => submit(context, logic.acceptRequest, uid), child: Text("Accept")));
      else if (status == "ACCEPTED")
        actions.add(ElevatedButton(
          onPressed: () => submit(context, logic.optOutRequest, uid),
          child: Text("Opt Out"),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
        ));
    }
    
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title),
        subtitle: Text("Created by $creator"),
        trailing: Column(
          mainAxisSize: .min, spacing: 5,
          children: [
            StatusChip(status),
            Text(DateFormat("dd/MM/yy").format(date))
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context, 
            builder: (ctx) => CustomSheet(Container(
              padding: EdgeInsets.all(20),
              child: Column(mainAxisSize: .min, crossAxisAlignment: .stretch, spacing: 15, children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(desc),
                
                ...actions
              ]),
            ))
          );
        },
      )
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;
  static const COLORS = {
    "PENDING": Colors.blue,
    "ACCEPTED": Colors.yellow,
    "CANCELLED": Colors.red,
    "COMPLETED": Colors.green
  };
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: COLORS[status]
      ),
      child: Text(status, style: TextStyle(
        color: Colors.white, fontSize: 12
      )),
    );
  }
}
