import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/provider/db.dart';
import 'package:focus/pkg/provider/db_provider.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:sprintf/sprintf.dart';

class Add extends StatefulWidget {
  String identity = "";
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  FormUtil fu = FormUtil(
    title: "Plan",
    fis: [
      FormItem(field: "name", title: "名称"),
      FormItem(field: "desc", defaultValue: "default desc", title: "描述"),
      FormItem(field: "report", title: "是否重复", type: FormItemType.switchType, defaultValue: false),
    ],
  );

  @override
  initState() {
    super.initState();
  }

  void fetch() {
    
  }

  Future<Ngrok?>? _fetch;


  @override
  Widget build(BuildContext context) {
    return fu.view(context);
  }
}
