import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TotalPurchase extends StatefulWidget {
  @override
  _TotalPurchaseState createState() => _TotalPurchaseState();
}

class _TotalPurchaseState extends State<TotalPurchase> {
  double _dollarPrice = 0;
  double _totalValue = 0;
  Future<double> _total;

  @override
  void initState() {
    super.initState();
    _total = _getTotalValue();
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
                _dollarPrice =
                    double.parse(snapshot.data.documents[0].documentID);
                return snapshot.data == null
                    ? Text("Carregando")
                    : Text(
                        "Valor Dolar R\$ ${snapshot.data.documents[0].documentID}");
              },
            ),
            Text(
              "Total em U\$",
              style: TextStyle(fontSize: 30),
            ),
            FutureBuilder<double>(
                future: _total,
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.data != null)
                    Text(
                      "${snapshot.data}",
                      style: TextStyle(fontSize: 60, color: Colors.red),
                    );
                  else
                    Text(
                      "Carregando...",
                      style: TextStyle(fontSize: 60, color: Colors.red),
                    );
                }),
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

  Future<double> _getTotalValue() async {
    var database = await openDatabase('purchase_database.db');

    var result =
        await database.rawQuery('select sum(fullProductPrice) from purchase');

    // return Text(
    //   result[0]["sum(fullProductPrice)"] != null
    //       ? result[0]['sum(fullProductPrice)']
    //       : 0,
    //   style: TextStyle(fontSize: 60, color: Colors.red),
    // );

    if (result[0]['sum(fullProductPrice)'] != null)
      return double.parse(result[0]['sum(fullProductPrice)']);
    else
      return 0;
  }
}
