import 'package:flutter/material.dart';
import 'package:focus/pkg/fetch/ngrok.dart';
import './item.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<NgrokAgent> ngl = [];

  _DemoState() {
    Ngrok("2Bk4TjVjGYgW443S5vCbcdGlrWN_5dqQ3WV4GF6wkkBuaXM9y")
        .agent()
        .then((value) => this.setState(() {
              ngl = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngrok'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/ngrok/add");
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        color: Colors.grey[150],
        child: ListView(children: ngl.map((e) => Item(e)).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) => {},
      ),
    );
  }
}
