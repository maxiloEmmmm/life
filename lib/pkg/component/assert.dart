import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class Assert extends StatelessWidget {
  bool i;
  Widget a, b;
  Assert(this.i, this.a, this.b);

  @override
  Widget build(BuildContext context) {
    return i ? a : b;
  }
}

class IfTrue extends StatelessWidget {
  bool i;
  Widget a;
  IfTrue(this.i, this.a);

  @override
  Widget build(BuildContext context) {
    return i ? a : Container();
  }
}

class IfFalse extends IfTrue {
  IfFalse(bool i, Widget a) : super(!i, a);
}
