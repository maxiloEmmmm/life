import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sprintf/sprintf.dart';

class ItemAction<T> {
  Widget icon;
  Function(T?, void Function() refresh) cb;
  ItemAction({
    required this.icon,
    required this.cb
  });
}

class Item<T> extends StatefulWidget {
  String type;
  List<ItemAction<T>>? actions;
  String Function(T)? title;
  Function(T)? onRemove;
  Function(T, void Function() refresh)? onUpdate;
  Future<T?> Function() fetch;
  Widget Function(BuildContext, T?) content;
  Item({
    required this.type,
    required this.fetch,
    required this.content,
    this.title,
    this.onRemove,
    this.onUpdate,
    this.actions
  });

  @override
  State<Item> createState() => _ItemState<T>();
}

class _ItemState<T> extends State<Item<T>> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<T>? _fetch;

  void refresh() {
    _fetch = widget.fetch() as Future<T>;
  }

  void doFetch() {
    setState(() {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _fetch,
      builder: (context, snapshot) {
          List<Widget> sBtn = [];
          if(snapshot.data != null) {
            sBtn.addAll([
              SlidableAction(
                  onPressed: (BuildContext context) {
                    if(widget.onRemove != null) {
                      widget.onRemove!(snapshot.data!);
                    }
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '干掉',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) {
                    if(widget.onUpdate != null) {
                      widget.onUpdate!(snapshot.data!, doFetch);
                    }
                  },
                  backgroundColor: Colors.blue.shade200,
                  foregroundColor: Colors.white,
                  icon: Icons.update,
                  label: '改变',
                ),
            ]);
          }

          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: sBtn,
            ),
            child: view(context, snapshot.data, snapshot.connectionState != ConnectionState.done),
          );
      },
    );
  }

  Widget view(BuildContext context, T? ii, bool loading) {
    List<Widget> btns = [];
    
    if(loading) {
      btns.add(Container(child: const CupertinoActivityIndicator(), padding: EdgeInsets.all(12)));
    }else {
      widget.actions?.forEach((e) {
        btns.add(IconButton(onPressed: () => e.cb(ii, doFetch), icon: e.icon));
      });
      btns.add(IconButton(onPressed: () => doFetch(), icon: const Icon(Icons.refresh)));
    }

    String title = "-";
    if(widget.title != null && ii != null) {
      title = widget.title!(ii);
    }

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
                          Text(widget.type, style: TextStyle(color: Colors.white)),
                      color: Colors.orange,
                      padding: EdgeInsets.all(2),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(title),
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.orange, width: 4))),
                        )),
                    //  todo: add refresh
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: btns,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: loading ? const Text("...") : widget.content(context, ii),
          )
        ],
      ),
    );
  }
}