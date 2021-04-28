import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TotalPurchase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Total da compra"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total em U\$",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "1000",
              style: TextStyle(fontSize: 60, color: Colors.red),
            ),
            SizedBox(height: 60),
            Text(
              "Total em R\$",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "1000",
              style: TextStyle(fontSize: 60, color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
