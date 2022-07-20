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
  static const String plansField = "plans";

  @override
  initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    _fetch = () async {
      AppDB appDB = await Application.instance!.make("app_db");
      
      var planOptions = (await appDB.planClient.all()).map((e) => CheckboxKitOption(
        label: e.name!, 
        value: e.id,
        desc: e.desc!)).toList();
      var thingOptions = (await appDB.thingClient.all()).map((e) => CheckboxKitOption(
        label: e.name!, 
        value: e.id,
        desc: e.desc!)).toList();

      if(thingOptions.isEmpty) {
        tip.TextAlertDescWithCB(context, "毫无奖品", () => Navigator.pop(context));
        return;
      }

      if(planOptions.isEmpty) {
        tip.TextAlertDescWithCB(context, "毫无计划", () => Navigator.pop(context));
        return;
      }
      
      fu = FormUtil(
        title: "Award",
        fis: [
          FormItem(field: AwardClient.nameField, title: "名称", validate: (value) => value as String != ""),
          FormItem(field: AwardClient.descField, title: "描述"),
          FormItem(field: thingField, title: "礼物!", type: FormItemType.radioType, option: {
            checkboxOptions: thingOptions,
          }),
          FormItem(field: plansField, title: "计划", type: FormItemType.checkboxType, option: {
            checkboxOptions: planOptions,
          }, validate: (value) => (value as List).isNotEmpty),
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
            widget.identity = await appDB.awardClient.insert(AwardJSONHelp.fromJson(data.data));
          }else {
            await appDB.awardClient.update(widget.identity, AwardJSONHelp.fromJson(data.data));
          }

          await appDB.awardClient.setPlans(widget.identity, (data.data[plansField] as List).map((e) => e as int).toList());
          await appDB.awardClient.setThing(widget.identity, data.data[thingField]);

          tip.TextAlertDescWithCB(context, "一切都好", () => Navigator.pop(context));
        }
      );

      if(widget.identity != 0) {
        try {
          var p = await appDB.awardClient.first(widget.identity);
          var plans = await appDB.awardClient.getPlans(p!.id!);
          var thing = await appDB.awardClient.getThing(p.id!);
          fu!.setValue({
            AwardClient.nameField: p.name,
            AwardClient.descField: p.desc,
            thingField: thing!.id,
            plansField: plans.map((e) => e.id).toList()
          });
        }catch(e) {
          tip.TextAlertDescWithCB(context, e.toString(), () => Navigator.pop(context));
        }
      }
    }();
  }

  Future<void>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetch,
      builder: (context, snapshot) {
        if(fu != null && snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.none) {
          return fu!.view(context);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
