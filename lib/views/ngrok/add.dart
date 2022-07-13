import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';
import 'package:sprintf/sprintf.dart';

class Add extends StatefulWidget {
  String identity = "";
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  initState() {
    super.initState();
    if(widget.identity.isNotEmpty) {
      fetch();
    }
  }

  void fetch() {
    setState(() {
      _fetch = () async {
        try {
          var db = await (await Application.instance!.make("sqlite") as sqlite).DB();
          var ngrok = await db!.rawQuery("select * from ngrok where identity = ?", [widget.identity]);
          if(ngrok.isEmpty) {
            throw "记录不存在!";
          } 
          return ngrok[0];
        }catch(e) {
          tip.TextAlertDescWithCB(context, sprintf("[%s] %s", [widget.identity, e.toString()]), () {
            Navigator.pop(context);
          });
          return null;
        }
      }();
    });
  }

  Future<Map?>? _fetch;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController apiKeyC = TextEditingController();
  TextEditingController identityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.none || snapshot.hasData) {
          return view(context, snapshot.data);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
  
  Widget view(BuildContext context, Map? data) {
    identityC.text = data?["identity"] ?? "";
    apiKeyC.text = data?["api_key"] ?? "";
    return Scaffold(
        appBar: AppBar(
          title: Text(data == null ? '新的ngrok' : '焕然一新的ngrok'),
          actions: [
            Container(
              width: 60,
              child: CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Done"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      var db = await (await Application.instance!.make("sqlite") as sqlite).DB();
                      var ngrokClient = NgrokClient(db!);
                      if(data == null) {
                        var record = await ngrokClient.first(identityC.text);
                        if (record != null) {
                          tip.TextAlertDesc(this.context, sprintf("%s 已新增", [identityC.text]));
                          return;
                        }

                        await ngrokClient.insert(Ngrok(identity: identityC.text, apiKey: apiKeyC.text));
                      }else {
                        await ngrokClient.update(widget.identity, Ngrok(apiKey: apiKeyC.text));
                      }
                      
                      tip.TextAlertDescWithCB(this.context, "成功!", () => Navigator.pop(context));
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
