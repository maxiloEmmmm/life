import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CheckboxKitOption {
  String label;
  String desc;
  dynamic value;
  CheckboxKitOption({
    required this.label,
    required this.value,
    this.desc = ""
  });
}

class CheckboxKitItem extends StatefulWidget {
  String label;
  String desc;
  bool defaultCheck;
  Function(bool check)? change; 
  CheckboxKitItem({
    this.change,
    this.defaultCheck = false,
    this.desc = "",
    required this.label
  });

  @override
  State<CheckboxKitItem> createState() => _CheckboxKitItemState();
}

class _CheckboxKitItemState extends State<CheckboxKitItem> {
  bool check = false;

  @override
  void initState() {
    super.initState();
    check = widget.defaultCheck;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          check = !check;
        });
        if(widget.change != null) {
          widget.change!(check);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.normal , decoration: TextDecoration.none)),
              widget.desc == "" ? Container() : Text(widget.desc, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal , decoration: TextDecoration.none)),
            ],
          ),
          check ? const Icon(Icons.done) : Container()
        ]),
      ),
    );
  }
}

class CheckboxKit extends StatefulWidget {
  List<CheckboxKitOption> checks = [];
  List value = [];
  Function(List)? change;
  bool unique;
  CheckboxKit({
    this.checks = const [],
    this.change,
    this.unique = false,
    this.value = const []
  });

  @override
  State<CheckboxKit> createState() => _CheckboxKitState();
}

class _CheckboxKitState extends State<CheckboxKit> {
  var textController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: CupertinoSearchTextField(controller: textController),
        ),
        ...widget.checks.where((element) => textController.text == "" || element.label.contains(textController.text) || element.desc.contains(textController.text)).map((e) => CheckboxKitItem(
              label: e.label,
              desc: e.desc,
              defaultCheck: widget.value.contains(e.value), 
              change: (check){
                setState(() {
                  if(widget.unique) {
                    widget.value = [e.value];
                  }else {
                    var set = widget.value.toSet();
                    if(check) {
                      set.add(e.value);
                    }else {
                      set.remove(e.value);
                    }
                    widget.value = set.toList();
                  }
                  if(widget.change != null) {
                    widget.change!(widget.value);
                  }
                });
              })
        ).toList()
      ],
    ));
  }
}