import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FormItemType {
  stringType,
  intType,
  doubleType,
  switchType,
  sliderType,
}

class FormItem {
  String? title;
  String help;
  bool Function(dynamic value)? validate;
  FormItemType type;
  bool disable;
  dynamic defaultValue;
  String field;

  FormItem({
    required this.field,
    this.title,
    this.help = "错误",
    this.validate,
    this.defaultValue,
    this.disable = false,
    this.type = FormItemType.stringType,
  }) {
    validate ??= (value) => true;
  }
}

class FormData {
  Map<String, dynamic> data;
  bool valid;
  Map<String, bool> validateMap;
  FormData({
    required this.data,
    required this.valid,
    required this.validateMap
  });
}

class FormUtil {
  String? title;
  List<FormItem> fis = [];
  Map<String, dynamic> valueSet = {};
  Map<String, bool> validateSet = {};
  Map<String, FormItem> formItemMap = {};
  Function()? change;
  Function(FormData data)? save;

  FormUtil({
    this.title,
    required this.fis,
    this.change,
    this.save,
  }) {
    fis.forEach((element) {
      validateSet[element.field] = true;
      formItemMap[element.field] = element;
      switch(element.type) {
        case FormItemType.stringType:
        case FormItemType.intType:
        case FormItemType.doubleType:
          var c = TextEditingController();
          c.addListener(() {
            onChange(field: element.field);
          });
          valueSet[element.field] = c;
          c.value = TextEditingValue(text: element.defaultValue ?? "");
          break;
        case FormItemType.sliderType:
          var value = 0.0;
          if(element.defaultValue is double) {
            value = element.defaultValue as double;
          }
          if(value > 100 || value < 0) {
            value = 0;
          }
          valueSet[element.field] = value;
          break;
        case FormItemType.switchType:
          var value = false;
          if(element.defaultValue is bool) {
            value = element.defaultValue as bool;
          }
          valueSet[element.field] = value;
          break;
      }

      onChange(field: element.field);
    });
  }

  Map<String, dynamic> valueMap() {
    Map<String, dynamic> ret = {};
    formItemMap.forEach((key, val) {
      ret[key] = value(val);
    });
    return ret;
  }

  dynamic value(FormItem item) {
    switch(item.type) {
      case FormItemType.stringType:
      case FormItemType.intType:
      case FormItemType.doubleType:
        return (valueSet[item.field] as TextEditingController).text;
      case FormItemType.sliderType:
      case FormItemType.switchType:
        return valueSet[item.field];
      default:
        return null;
    }
  }

  onChange({
    required String field}) {
    var fi = formItemMap[field]!;
    validateSet[field] = fi.validate!(value(fi));
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
            errorText: !validateSet[fi.field]! ? fi.help : null,
          ),
        );
      case FormItemType.intType:
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          controller: valueSet[fi.field],
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: fi.title ?? "",
            errorText: !validateSet[fi.field]! ? fi.help : null,
          ),
        );
      case FormItemType.doubleType:
        return TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: valueSet[fi.field],
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: fi.title ?? "",
            errorText: !validateSet[fi.field]! ? fi.help : null,
          ),
        );
      case FormItemType.sliderType:
        return Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
              color: Colors.grey.shade500, 
              width: 1))
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Flexible(child: Row(
                children: [
                  Text("${fi.title ?? ""}(${valueSet[fi.field]})"),
                  const Spacer(flex: 2),
                  Expanded(flex: 8, child: CupertinoSlider(
                    value: valueSet[fi.field],
                    divisions: 10,
                    max: 100,
                    activeColor: CupertinoColors.systemPurple,
                    thumbColor: CupertinoColors.systemPurple,
                    onChanged: (double value) {
                      valueSet[fi.field] = value;
                      onChange(field: fi.field);
                    },
                  ),)
                ],
              )),
              Container(child: Row(children: !validateSet[fi.field]! ? [Text(fi.help, style: TextStyle(color: Colors.red),)] : []), height: 20,)
            ],
          ),
        );
      case FormItemType.switchType:
        return Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
              color: Colors.grey.shade500, 
              width: 1))
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Flexible(child: Row(
                children: [
                  Text(fi.title ?? ""),
                  const Spacer(flex: 8),
                  Expanded(flex: 2, child: CupertinoSwitch(
                    value: valueSet[fi.field],
                    onChanged: (bool value) {
                      valueSet[fi.field] = value;
                      onChange(field: fi.field);
                    },
                  ))
                ],
              )),
              Container(child: Row(children: !validateSet[fi.field]! ? [Text(fi.help, style: TextStyle(color: Colors.red),)] : []), height: 20,)
            ],
          ),
        );
      default:
        return Text("unknown type ${fi.type}");
    }
  }

  bool get valid {
    return validateSet.values.every((element) => element);
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
                  if(save != null) {
                    save!(FormData(data: valueMap(), valid: valid, validateMap: validateSet));
                  }
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