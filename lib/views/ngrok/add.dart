import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';
import 'package:sprintf/sprintf.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  initState() {

  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController apiKeyC = TextEditingController();
  TextEditingController identityC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('新的ngrok'),
          actions: [
            Container(
              width: 60,
              child: CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("Done"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      var db = await (await Application.instance!.make("sqlite") as sqlite).DB();
                      var rows = await db!.rawQuery("select * from ngrok where identity = ? limit 1", [identityC.text]);
                      if (rows.isNotEmpty) {
                        tip.TextAlertDesc(this.context, sprintf("%s 已新增", [identityC.text]));
                        return;
                      }

                      await db.insert("ngrok", {
                        "identity": identityC.text,
                        "api_key": apiKeyC.text,
                      });
                    } catch (e) {
                      tip.TextAlertWithOutCB(this.context, "异常!", e.toString());
                    }
                    return;
                  }

                  tip.TextAlertWithOutCB(context, "这里", "有点问题啊");
                },
              ),
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: identityC,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    icon: Icon(Icons.book),
                    labelText: '可识别的名称',
                  ),
                  autofocus: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '不能空';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: apiKeyC,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    icon: Icon(Icons.key),
                    labelText: 'API_Key',
                  ),
                  autofocus: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '不能空';
                    }
                    return null;
                  },
                ),
              ],
            )));
  }
}
