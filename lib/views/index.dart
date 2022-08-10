import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  const Index();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.pink.shade200,
                      )),
                      child: Text("Ngrok"),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/ngrok");
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.pink.shade200,
                      )),
                      child: Text("Plan"),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/plan");
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.pink.shade200,
                      )),
                      child: Text("Thing"),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/thing");
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.pink.shade200,
                      )),
                      child: Text("Award"),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/award");
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.pink.shade200,
                      )),
                      child: Text("Habit"),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/habit");
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
