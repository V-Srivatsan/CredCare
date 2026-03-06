import 'package:credcare/widgets/bottom_sheet.dart';
import 'package:credcare/widgets/input.dart';
import 'package:flutter/material.dart';

import 'logic.dart' as logic;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewCommunity extends StatefulWidget {
  const NewCommunity({super.key});

  @override
  State<NewCommunity> createState() => _NewCommunityState();
}

class _NewCommunityState extends State<NewCommunity> {
  bool loading = false;
  final _key = GlobalKey<FormBuilderState>();

  void submit() async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; });

    final res = await logic.createCommunity(_key.currentState!.value["name"]);

    if (res.success)
      Navigator.pop(context, true);
    else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data["detail"]["message"])));

    setState(() { loading = false; });
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomSheet(Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: FormBuilder(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Input(label: "Community Name", name: "name", fill: Color(0xFFF6F6F8)),
            ElevatedButton(onPressed: loading ? null : submit, child: Text("Create Community"))
          ],
        ),
      ),
    ));
  }
}
