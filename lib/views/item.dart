import 'package:flutter/material.dart';
import 'package:focus/pkg/fetch/ngrok.dart';
import 'package:sprintf/sprintf.dart';

class Item extends StatelessWidget {
  NgrokAgent? ng;
  Item(this.ng);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 34),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0.0, 5.0),
            blurRadius: 6.0),
      ]),
      child: Column(
        children: [
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    left: 0,
                    top: -20,
                    child: Container(
                      child:
                          Text("Ngrok", style: TextStyle(color: Colors.white)),
                      color: Colors.orange,
                      padding: EdgeInsets.all(2),
                    )),
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(sprintf("NO.%s", [ng!.id])),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange, width: 4))),
                        )),
                    Expanded(flex: 2, child: Text("01/24")),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sprintf("Addr: %s", [ng!.publicUrl])),
                  Text(sprintf("Nat: %s", [ng!.forwardsTo])),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
