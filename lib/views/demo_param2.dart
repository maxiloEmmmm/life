import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DemoParam2 extends StatelessWidget {
  int id = 0;
  int q = 0;

  DemoParam2(int id, int q) {
    this.id = id;
    this.q = q;
  }

  @override
  Widget build(BuildContext context) {
    return Text((id + q).toString());
  }
}
