import 'package:flutter/material.dart';
import 'package:focus/pkg/component/checkbox.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/award.dart';
import 'package:focus/pkg/provider/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:focus/pkg/util/transform.dart';
import 'package:maxilozoz_box/application.dart';

class Add extends StatefulWidget {
  int identity = 0;
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  FormUtil? fu;

  static const String thingField = "thing";

  @override
  initState() {
    super.initState();
    fu = FormUtil(
      title: "Award",
      fis: [
        FormItem(field: AwardClient.nameField, title: "名称", validate: (value) => value as String != ""),
        FormItem(field: AwardClient.descField, title: "描述"),
        FormItem(field: thingField, title: "礼物!", type: FormItemType.checkboxType, option: {
          "checkboxOptions": [
            CheckboxKitOption(label: "a", value: 0, desc: "123"),
            CheckboxKitOption(label: "b", value: 1),
            CheckboxKitOption(label: "c", value: 2),
            CheckboxKitOption(label: "d", value: 3),
          ]
        }),
      ],
      change: () {
        setState(() {
          
        });
      },
      save: (FormData data) async {
        if(!data.valid) {
          tip.TextAlertDesc(context, "请检查!");
          return;
        }

        AppDB appDB = await Application.instance!.make("app_db");

        map2DB(data.data);
        if(widget.identity == 0) {
          await appDB.awardClient.insert(AwardJSONHelp.fromJson(data.data));
        }else {
          await appDB.awardClient.update(widget.identity, AwardJSONHelp.fromJson(data.data));
        }

        tip.TextAlertDescWithCB(context, "一切都好", () => Navigator.pop(context));
      }
    );

    if(widget.identity != 0) {
      try {
        fetch();
      }catch(e) {
        tip.TextAlertDescWithCB(context, e.toString(), () => Navigator.pop(context));
      }
    }
  }

  void fetch() {
    _fetch = () async {
      AppDB appDB = await Application.instance!.make("app_db");
      var p = await appDB.awardClient.first(widget.identity);
      fu!.setValue({
        AwardClient.nameField: p!.name,
        AwardClient.descField: p.desc,
      });
      return p;
    }();
  }

  Future<Award?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Award?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.none) {
          return fu!.view(context);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
