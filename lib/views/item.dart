import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 34),
      height: 200,
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0.0, 5.0),
            blurRadius: 6.0),
      ]),
      child: Column(
        children: [
          Expanded(
            flex: 2,
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
                          child: Text("今天是个好日子"),
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
          Expanded(
              flex: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("content")],
              )),
        ],
      ),
    );
  }
}
