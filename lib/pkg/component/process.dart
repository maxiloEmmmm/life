import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Process extends StatelessWidget {
  double percent;
  Color color;
  Process(this.percent, {this.color = Colors.red}) {
    if (percent > 1) {
      percent = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth * percent,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            )
          ],
        ),
      );
    });
  }
}
