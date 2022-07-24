import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:sprintf/sprintf.dart';

class Add extends StatefulWidget {
  int identity = 0;
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  initState() {
    super.initState();
    if (widget.identity != 0) {
      fetch();
    }
  }

  void fetch() {
    setState(() {
      _fetch = () async {
        try {
          DBClientSet appDB = await Application.instance!.make("app_db");
          var ngrok = await appDB.Ngrok().first(widget.identity);
          if (ngrok == null) {
            throw "记录不存在!";
          }
          return ngrok;
        } catch (e) {
          tip.TextAlertDescWithCB(
              context, sprintf("[%s] %s", [widget.identity, e.toString()]), () {
            Navigator.pop(context);
          });
          return null;
        }
      }();
    });
  }

  Future<NgrokType?>? _fetch;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController apiKeyC = TextEditingController();
  TextEditingController identityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NgrokType?>(
      future: _fetch,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.hasData) {
          return view(context, snapshot.data);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, NgrokType? data) {
    identityC.text = data?.identity ?? "";
    apiKeyC.text = data?.apiKey ?? "";
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
                      await (await (await Application.instance!.make("app_db")).Ngrok().firstOrNew(widget.identity))
                          .fillByType(NgrokType(
                            apiKey: apiKeyC.text,
                            identity: identityC.text,
                          ))
                          .save();

                      tip.TextAlertDescWithCB(
                          this.context, "成功!", () => Navigator.pop(context));
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
