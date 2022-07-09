import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DemoParam extends StatelessWidget {
  int id = 0;

  DemoParam(int id) {
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return Text(id.toString());
  }
}
