import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TotalPurchase extends StatefulWidget {
  @override
  _TotalPurchaseState createState() => _TotalPurchaseState();
}

class _TotalPurchaseState extends State<TotalPurchase> {
  double _totalValue = 0;

  @override
  void initState() {
    super.initState();
    _getTotalValue();
  }

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
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("dollarprice").snapshots(),
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Text("Carregando...")
                    : Text(
                        "Valor do dólar R\$${snapshot.data.documents[0].documentID}",
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      );
              },
            ),
            SizedBox(height: 32),
            Text(
              "Total em U\$",
              style: TextStyle(fontSize: 32),
            ),
            Text(
              "${_totalValue.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 64, color: Colors.red),
            ),
            SizedBox(height: 58),
            Text(
              "Total em R\$",
              style: TextStyle(fontSize: 32),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("dollarprice").snapshots(),
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Text("Carregando...")
                    : Text(
                  '${(_totalValue * double.parse(snapshot.data.documents[0].documentID)).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 64, color: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getTotalValue() async {
    var database = await openDatabase('purchase_database.db');

    var result =
        await database.rawQuery('select sum(fullProductPrice) from purchase');

    setState(() {
      if (result[0]['sum(fullProductPrice)'] != null)
        _totalValue = result[0]['sum(fullProductPrice)'] as double;
      else
        _totalValue = 0;
    });
  }
}
