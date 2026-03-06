import 'package:credcare/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:credcare/widgets/input.dart';

import 'logic.dart' as logic;

class NewRequest extends StatefulWidget {
  const NewRequest({super.key});

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  final _key = GlobalKey<FormBuilderState>();
  bool loading = false;

  void submit() async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; });

    final data = _key.currentState!.value;
    final res = await logic.createRequest(data["title"], data["desc"]);

    if (res.success)
      Navigator.pop(context, true);
    else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data["detail"]["message"])));

    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheet(Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: FormBuilder(key: _key, child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10, crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Raise a Request", style: Theme.of(context).textTheme.titleLarge,),
          Input(label: "Title", name: "title"),
          Input(label: "Description", name: "desc", multiline: true),
          ElevatedButton(onPressed: loading ? null : submit, child: Text("Raise Request"))
        ],
      ))
    ));
  }
}
