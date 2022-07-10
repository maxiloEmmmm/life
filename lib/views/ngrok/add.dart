import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController apiKeyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('新的ngrok')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: apiKeyC,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                icon: Icon(Icons.key),
                labelText: 'API_Key',
              ),
              autofocus: false,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              margin: EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('错误!'),
                      content: const Text('这个还有那个'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          /// This parameter indicates the action would perform
                          /// a destructive action such as deletion, and turns
                          /// the action's text color to red.
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('不太行'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('Submit'),
              ),
            )
          ],
        ));
  }
}
