import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/util/tip.dart';

class Add extends StatefulWidget {
  String identity = "";
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  FormUtil? fu;

  @override
  initState() {
    super.initState();
    fu = FormUtil(
      title: "Plan",
      fis: [
        FormItem(field: "name", title: "名称"),
        FormItem(field: "desc", defaultValue: "default desc", title: "描述", help: "至少两个字符", validate: (value) => (value as String).length > 2),
        FormItem(field: "report", title: "是否重复", type: FormItemType.switchType, defaultValue: false, validate: (value) => value),
        FormItem(field: "boom", title: "滑动", help: "要大于50", type: FormItemType.sliderType, defaultValue: 50.0, validate: (value) => value as double > 50),
      ],
      change: () {
        setState(() {
          
        });
      },
      save: (FormData data) {
        if(!data.valid) {
          tip.TextAlertDesc(context, "请检查!");
          return;
        }

        tip.TextAlertDescWithCB(context, "一切都好 请在console查看数据!", () => print("${data.data}"));
      }
    );
  }

  void fetch() {
    
  }

  Future<Ngrok?>? _fetch;


  @override
  Widget build(BuildContext context) {
    return fu!.view(context);
  }
}
