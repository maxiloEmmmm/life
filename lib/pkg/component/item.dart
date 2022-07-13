import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sprintf/sprintf.dart';

abstract class ItemFetch {
  Future<ItemInfo> fetch();
  String identity();
  Future remove(BuildContext context);
  Future update(BuildContext context);
  String type();
}

abstract class ItemInfo {
  Widget child(BuildContext context);
}

class Item extends StatefulWidget {
  ItemFetch ng;
  Item(this.ng):super(key: ValueKey("${ng.type()}_${ng.identity()}"));

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
    setState(() {
      _fetch = widget.ng.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemInfo>(
      future: _fetch,
      builder: (context, snapshot) {
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    //todo 如果删除后 list页面会删除这个item 此时context无效 会爆炸
                    widget.ng.remove(context);
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '干掉',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    await widget.ng.update(context);
                    fetch();
                  },
                  backgroundColor: Colors.blue.shade200,
                  foregroundColor: Colors.white,
                  icon: Icons.update,
                  label: '改变',
                ),
              ],
            ),
            child: view(context, snapshot.data, snapshot.connectionState != ConnectionState.done),
          );
      },
    );
  }

  Widget view(BuildContext context, ItemInfo? ii, bool loading) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(sprintf("NO.%s", [ii == null ? "-" : widget.ng.identity()])),
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange, width: 4))),
                        )),
                    //  todo: add refresh
                    Container(
                      width: 20,
                      height: 20,
                      child: Stack( 
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            child: loading ? Container(child: const CupertinoActivityIndicator(), padding: EdgeInsets.all(12),) : IconButton(onPressed: () => fetch(), icon: const Icon(Icons.refresh)),
                            top: -8, right: -8,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: loading ? const Text("...") : ii!.child(context),
          )
        ],
      ),
    );
  }
}