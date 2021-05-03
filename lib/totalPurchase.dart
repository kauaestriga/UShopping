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
  double realValue = 0;
  double _totalValue = 0;

  @override
  void initState() {
    super.initState();
    _getTotalValue();
    _getDollarPrice();
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
                if (snapshot.data != null)
                  _dollarPrice =
                      double.parse(snapshot.data.documents[0].documentID);
                return snapshot.data == null
                    ? Text("Carregando")
                    : Text(
                        "Valor Dolar R\$ ${snapshot.data.documents[0].documentID}",
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      );
              },
            ),
            Text(
              "Total em U\$",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "${_totalValue.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 60, color: Colors.red),
            ),
            SizedBox(height: 60),
            Text(
              "Total em R\$",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              '${realValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 60, color: Colors.green),
            )
          ],
        ),
      ),
    );
  }

  double _getDollarPrice() {
    Firestore.instance.collection("dollarprice").getDocuments().then(
        (value) => _dollarPrice = value.documents[0].documentID as double);
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

      realValue = _totalValue * _dollarPrice;
      // _totalValue = double.parse(_totalValue.toStringAsFixed(2));
      _totalValue = double.parse(_totalValue.toString());
    });
  }
}
