import 'package:flutter/material.dart';
import 'package:flutter_app_ushopping/sqlite/addPurchase.dart';
import 'package:flutter_app_ushopping/totalPurchase.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UShopping',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/addPurchase' : (context) => AddPurchase(),
        '/totalPurchase' : (context) => TotalPurchase()
      },
    );
  }
}
