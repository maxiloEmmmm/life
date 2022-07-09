import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      color: Colors.white,
      height: 200,
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
                    Expanded(flex: 8, child: Text("今天是个好日子")),
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
