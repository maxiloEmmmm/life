import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus/pkg/component/checkbox.dart';

enum FormItemType {
  stringType,
  intType,
  doubleType,
  switchType,
  sliderType,
  datetimeType,
  timepickType,
  checkboxType,
  radioType
}

const checkboxOptions = "checkboxOptions";

class FormItem {
  String? title;
  String help;
  bool Function(dynamic value)? validate;
  FormItemType type;
  bool disable;
  dynamic defaultValue;
  String field;
  Map option;

  FormItem(
      {required this.field,
      this.title,
      this.help = "错误",
      this.validate,
      this.defaultValue,
      this.disable = false,
      this.type = FormItemType.stringType,
      this.option = const {}}) {
    validate ??= (value) => true;
  }
}

class FormData {
  Map<String, dynamic> data;
  bool valid;
  Map<String, bool> validateMap;
  FormData(
      {required this.data, required this.valid, required this.validateMap});
}

class FormUtil {
  String? title;
  List<FormItem> fis = [];
  Map<String, dynamic> valueSet = {};
  Map<String, bool> validateSet = {};
  Map<String, FormItem> formItemMap = {};
  Function()? change;
  Function(BuildContext context, FormData data)? save;

  FormUtil({
    this.title,
    required this.fis,
    this.change,
    this.save,
  }) {
    fis.forEach((element) {
      validateSet[element.field] = true;
      formItemMap[element.field] = element;
      switch (element.type) {
        case FormItemType.radioType:
          var opts = [];
          if (element.option[checkboxOptions] is List<CheckboxKitOption>) {
            opts = element.option[checkboxOptions];
          }

          if (opts.isEmpty) {
            throw "don't allow empty checkboxOptions on radioType";
          }

          List value = [opts[0].value];
          if (element.defaultValue != null) {
            value = [element.defaultValue];
          }
          valueSet[element.field] = value;
          break;
        case FormItemType.checkboxType:
          List value = [];
          if (element.defaultValue is List) {
            value = element.defaultValue;
          }
          valueSet[element.field] = value;
          break;
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
          if (element.defaultValue is double) {
            value = element.defaultValue as double;
          }
          if (value > 100 || value < 0) {
            value = 0;
          }
          valueSet[element.field] = value;
          break;
        case FormItemType.switchType:
          var value = false;
          if (element.defaultValue is bool) {
            value = element.defaultValue as bool;
          }
          valueSet[element.field] = value;
          break;
        case FormItemType.datetimeType:
          var value = DateTime.now();
          if (element.defaultValue is DateTime) {
            value = element.defaultValue as DateTime;
          }
          valueSet[element.field] = value;
          break;
        case FormItemType.timepickType:
          var value = DateTime.now();
          if (element.defaultValue is DateTime) {
            value = element.defaultValue as DateTime;
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
    switch (item.type) {
      case FormItemType.stringType:
        return (valueSet[item.field] as TextEditingController).text;
      case FormItemType.intType:
        try {
          return int.parse(
              (valueSet[item.field] as TextEditingController).text);
        } catch (e) {
          return 0;
        }
      case FormItemType.doubleType:
        try {
          return double.parse(
              (valueSet[item.field] as TextEditingController).text);
        } catch (e) {
          return 0;
        }
      case FormItemType.radioType:
        return (valueSet[item.field] as List).first;
      case FormItemType.checkboxType:
        List ret = [];
        (valueSet[item.field] as List).forEach((element) {
          ret.add(element);
        });
        return ret;
      case FormItemType.sliderType:
      case FormItemType.switchType:
      case FormItemType.datetimeType:
      case FormItemType.timepickType:
        return valueSet[item.field];
      default:
        return null;
    }
  }

  setValue(Map<String, dynamic> data) {
    data.forEach((key, value) {
      var fi = formItemMap[key];
      if (fi != null) {
        switch (fi.type) {
          case FormItemType.stringType:
          case FormItemType.intType:

          case FormItemType.doubleType:
            (valueSet[fi.field] as TextEditingController).value =
                TextEditingValue(text: "$value");
            break;
          case FormItemType.radioType:
            valueSet[key] = [value];
            break;
          case FormItemType.checkboxType:
            List ret = [];
            value.forEach((element) {
              ret.add(element);
            });
            valueSet[key] = ret;
            break;
          case FormItemType.sliderType:
          case FormItemType.switchType:
          case FormItemType.datetimeType:
          case FormItemType.timepickType:
            valueSet[key] = value;
        }
        onChange(field: key);
      }
    });
  }

  onChange({required String field}) {
    var fi = formItemMap[field]!;
    validateSet[field] = fi.validate!(value(fi));
    if (change != null) {
      // todo: 现在是由change提供setstate 刷新界面 后期可能有表单性能问题
      change!();
    }
  }

  void _showDateTimeDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void _showCheckboxDialog(BuildContext context, String title, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                child: Column(
                  children: [
                    CupertinoNavigationBar(
                      middle: Text(title),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Done"),
                      ),
                    ),
                    child,
                  ],
                ),
              ),
            ));
  }

  Widget input(BuildContext context, FormItem fi) {
    switch (fi.type) {
      case FormItemType.stringType:
        return TextField(
          controller: valueSet[fi.field],
          maxLines:
              fi.option["maxLine"] is int ? fi.option["maxLine"] as int : 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: fi.title ?? "",
            errorText: !validateSet[fi.field]! ? fi.help : null,
          ),
        );
      case FormItemType.intType:
        return TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[-0-9]+"))
          ],
          controller: valueSet[fi.field],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: fi.title ?? "",
            errorText: !validateSet[fi.field]! ? fi.help : null,
          ),
        );
      case FormItemType.doubleType:
        return TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[-0-9.]+")),
          ],
          controller: valueSet[fi.field],
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
                  bottom: BorderSide(color: Colors.grey.shade500, width: 1))),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text("${fi.title ?? ""}(${valueSet[fi.field]})"),
                      const Spacer(flex: 2),
                      Expanded(
                        flex: 8,
                        child: CupertinoSlider(
                          value: valueSet[fi.field],
                          divisions: 10,
                          max: 100,
                          activeColor: CupertinoColors.systemPurple,
                          thumbColor: CupertinoColors.systemPurple,
                          onChanged: (double value) {
                            valueSet[fi.field] = value;
                            onChange(field: fi.field);
                          },
                        ),
                      )
                    ],
                  )),
              validateSet[fi.field]!
                  ? Container()
                  : Container(
                      child: Row(children: [
                        Text(
                          fi.help,
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                      height: 20,
                    )
            ],
          ),
        );
      case FormItemType.switchType:
        return Container(
          height: 64,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade500, width: 1))),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(fi.title ?? ""),
                      const Spacer(flex: 8),
                      Expanded(
                          flex: 2,
                          child: CupertinoSwitch(
                            value: valueSet[fi.field],
                            onChanged: (bool value) {
                              valueSet[fi.field] = value;
                              onChange(field: fi.field);
                            },
                          ))
                    ],
                  )),
              validateSet[fi.field]!
                  ? Container()
                  : Container(
                      child: Row(children: [
                        Text(
                          fi.help,
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                      height: 20,
                    )
            ],
          ),
        );
      case FormItemType.datetimeType:
      case FormItemType.timepickType:
        return Container(
          height: 56,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade500, width: 1))),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fi.title ?? ""),
                      Flexible(
                          child: GestureDetector(
                              // Display a CupertinoDatePicker in date picker mode.
                              onTap: () => _showDateTimeDialog(
                                    context,
                                    CupertinoDatePicker(
                                      initialDateTime: valueSet[fi.field],
                                      mode: fi.type == FormItemType.timepickType
                                          ? CupertinoDatePickerMode.time
                                          : CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      // This is called when the user changes the date.
                                      onDateTimeChanged: (DateTime value) {
                                        valueSet[fi.field] = value;
                                        onChange(field: fi.field);
                                      },
                                    ),
                                  ),
                              // In this example, the date value is formatted manually. You can use intl package
                              // to format the value based on user's locale settings.
                              child: Text(
                                fi.type == FormItemType.timepickType
                                    ? '${valueSet[fi.field].hour}点${valueSet[fi.field].minute}分'
                                    : '${valueSet[fi.field].month}-${valueSet[fi.field].day}-${valueSet[fi.field].year}',
                              )))
                    ],
                  )),
              validateSet[fi.field]!
                  ? Container()
                  : Container(
                      child: Row(children: [
                        Text(
                          fi.help,
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                      height: 20,
                    )
            ],
          ),
        );
      case FormItemType.radioType:
      case FormItemType.checkboxType:
        var text =
            ((fi.option[checkboxOptions] ?? []) as List<CheckboxKitOption>)
                .where((element) =>
                    (valueSet[fi.field] as List).contains(element.value))
                .map((e) => e.label)
                .toList()
                .join(",");
        return Container(
            height: 56,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade500, width: 1))),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _showCheckboxDialog(
                            context,
                            fi.title ?? "",
                            CheckboxKit(
                              value: valueSet[fi.field],
                              checks: fi.option["checkboxOptions"] ?? [],
                              unique: fi.type == FormItemType.radioType,
                              change: (List val) {
                                valueSet[fi.field] = val;
                                onChange(field: fi.field);
                              },
                            )),
                        child: Column(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(fi.title ?? ""),
                                Flexible(child: Text(text))
                              ],
                            )),
                            validateSet[fi.field]!
                                ? Container()
                                : Container(
                                    child: Row(children: [
                                      Text(
                                        fi.help,
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ]),
                                    height: 20,
                                  )
                          ],
                        )))
              ],
            ));
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
                  if (save != null) {
                    save!(
                        context,
                        FormData(
                            data: valueMap(),
                            valid: valid,
                            validateMap: validateSet));
                  }
                },
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: fis
                .map((field) => Flexible(child: input(context, field)))
                .toList(),
          ),
        ));
  }
}
