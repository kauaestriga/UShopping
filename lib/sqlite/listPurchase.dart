import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/purchase.dart';
import 'addPurchase.dart';

class ListPurchase extends StatefulWidget {
  @override
  _ListPurchaseState createState() => _ListPurchaseState();
}

class _ListPurchaseState extends State<ListPurchase> {
  Database _database;
  List<Purchase> purchaseList = <Purchase>[];

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  getDatabase() async {
    openDatabase(join(await getDatabasesPath(), 'purchase_database.db'),
            onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE purchase(id INTEGER PRIMARY KEY, productName TEXT, dollarProductPrice REAL, fullProductPrice REAL, image TEXT, state TEXT, isCard INTEGER)",
      );
    }, version: 1)
        .then((db) {
      setState(() {
        _database = db;
      });
      readAll();
    });
  }

  readAll() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('purchase');
      purchaseList = List.generate(maps.length, (i) {
        return Purchase(
            id: maps[i]['id'],
            productName: maps[i]['productName'],
            dollarProductPrice: maps[i]['dollarProductPrice'],
            fullProductPrice: maps[i]['fullProductPrice'],
            image: maps[i]['image'],
            state: maps[i]['state'],
            isCard: maps[i]['isCard']
        );
      });

      setState(() {});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de compras"),
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.pushNamed(context, "/totalPurchase");
              })
        ],
      ),
      body: ListView.separated(
        itemCount: purchaseList.length,
        itemBuilder: (context, index) => buildListItem(index, context),
        separatorBuilder: (context, index) => Divider(
          height: 1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPurchase()))
                .then((newPurchase) {
              if (newPurchase != null) {
                insertPurchase(newPurchase);
              }
            });
          }),
    );
  }

  Widget buildListItem(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Text("${purchaseList[index].id}"),
          title: Text("${purchaseList[index].productName}"),
          subtitle: Text("${purchaseList[index].dollarProductPrice}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddPurchase(purchaseItem: purchaseList[index])))
                .then((updatedPurchase) {
                  if (updatedPurchase != null) {
                    updatePurchase(updatedPurchase);
                  }
                });
            },
          onLongPress: () {
            deletePerson(index);
          },
        ),
      ),
    );
  }

  insertPurchase(Purchase purchase) {
    _database
        .insert(
      'purchase',
      purchase.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      purchase.id = value;
      setState(() {
        purchaseList.add(purchase);
      });
    });
  }

  updatePurchase(Purchase purchase) {
    _database
        .update(
      'purchase',
      purchase.toMap(),
      where: "id = ?",
      whereArgs: [purchase.id],
    ).then((value) {
      setState(() {
        purchaseList.clear();
        readAll();
      });
    });
  }

  deletePerson(int index) {
    _database.delete(
      'purchase',
      where: "id = ?",
      whereArgs: [purchaseList[index].id],
    ).then((value) {
      setState(() {
        purchaseList.removeAt(index);
      });
    });
  }
}
