import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showDialog(BuildContext context, String title, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                child: Column(
                  children: [
                    CupertinoNavigationBar(
                      middle: Text(title),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Done"),
                      ),
                    ),
                    child,
                  ],
                ),
              ),
            ));
  }