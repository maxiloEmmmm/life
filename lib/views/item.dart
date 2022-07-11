import 'package:flutter/material.dart';
import 'package:focus/pkg/fetch/ngrok.dart';
import 'package:sprintf/sprintf.dart';

abstract class ItemFetch {
  Future<ItemInfo> fetch();
  String type();
}

abstract class ItemInfo {
  String identity();
  Widget child(BuildContext context);
}

class Item extends StatefulWidget {
  ItemFetch ng;
  Item(this.ng);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<ItemInfo>? _fetch;

  void fetch() {
    _fetch = widget.ng.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemInfo>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return view(context, snapshot.data!);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, ItemInfo ii) {
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
                          Text(widget.ng.type(), style: TextStyle(color: Colors.white)),
                      color: Colors.orange,
                      padding: EdgeInsets.all(2),
                    )),
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(sprintf("NO.%s", [ii.identity()])),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange, width: 4))),
                        )),
                    //  todo: add refresh
                    // Expanded(flex: 2, child: Text("01/24")),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: ii.child(context),
          )
        ],
      ),
    );
  }
}