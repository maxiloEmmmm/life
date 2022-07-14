import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FormItemType {
  stringType,
  intType,
  doubleType,
  switchType,
}

class FormItem {
  String? title;
  String? help;
  bool Function(dynamic value)? validate;
  FormItemType type;
  bool disable;
  dynamic defaultValue;
  String field;

  FormItem({
    required this.field,
    this.title,
    this.help,
    this.validate,
    this.defaultValue,
    this.disable = false,
    this.type = FormItemType.stringType,
  });
}

class FormUtil {
  String? title;
  List<FormItem> fis = [];
  Map<String, dynamic> valueSet = {};
  Function()? change;

  FormUtil({
    this.title,
    required this.fis,
    this.change,
  }) {
    fis.forEach((element) {
      switch(element.type) {
        case FormItemType.stringType:
        case FormItemType.intType:
        case FormItemType.doubleType:
          var c = TextEditingController();
          c.addListener(onChange);
          c.text = element.defaultValue ?? "";
          valueSet[element.field] = c;
          break;
        case FormItemType.switchType:
          var value = false;
          if(element.defaultValue is bool) {
            value = element.defaultValue as bool;
          }
          valueSet[element.field] = value;
          break;
      }
    });
  }

  onChange() {
    if(change != null) {
      change!();
    }
  }

  Widget input(FormItem fi) {
    switch(fi.type) {
      case FormItemType.stringType:
        return TextField(
          controller: valueSet[fi.field],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: fi.title ?? "",
          ),
        );
      case FormItemType.intType:
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          controller: valueSet[fi.field],
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: fi.title ?? "",
          ),
        );
      case FormItemType.doubleType:
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: valueSet[fi.field],
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: fi.title ?? "",
          ),
        );
      case FormItemType.switchType:
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
              color: Colors.grey.shade500, 
              width: 1))
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Text(fi.title ?? ""),
              const Spacer(flex: 8),
              Expanded(flex: 2, child: CupertinoSwitch(
                value: valueSet[fi.field],
                onChanged: (bool value) {
                  valueSet[fi.field] = value;
                  onChange();
                },
              ))
            ],
          ),
        );
      default:
        return Text("unknown type ${fi.type}");
    }
  }

  Widget view(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? "empty title"),
          actions: [
            Container(
              width: 60,
              child: CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Done"),
                onPressed: () async {
                  print("done");
                },
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: fis.map((field) => Flexible(child: input(field))).toList(),
          ),
        )
    );
  }
}