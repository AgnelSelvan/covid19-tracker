import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (MediaQuery.of(context).size.height / 2) - 70,
      right: -20,
      child: AlertDialog(
        title: Text("Internet"),
        content: Text("Stay connected to internet to be up-to-date"),
        actions: [],
      ),
    );
  }
}
