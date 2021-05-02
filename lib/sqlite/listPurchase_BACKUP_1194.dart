import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/purchase.dart';
import 'addPurchase.dart';
import 'package:flutter_app_ushopping/utils/ImageUtils.dart';

class ListPurchase extends StatefulWidget {
  @override
  _ListPurchaseState createState() => _ListPurchaseState();
}

class _ListPurchaseState extends State<ListPurchase> {
  Database database;
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
        database = db;
      });
      readAll();
    });
  }

  readAll() async {
<<<<<<< HEAD
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
=======
    try {
      final List<Map<String, dynamic>> maps = await database.query('purchase');
      purchaseList = List.generate(maps.length, (i) {
        return Purchase(
            id: maps[i]['id'],
            productName: maps[i]['productName'],
            dollarProductPrice: maps[i]['dollarProductPrice'],
            fullProductPrice: maps[i]['fullProductPrice'],
            image: maps[i]['image'],
            state: maps[i]['state'],
            isCard: maps[i]['isCard']);
      });
>>>>>>> f6edd7868245e71d30ce44718576d89af6fb1753

    setState(() {});
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
      body: purchaseList.length == 0
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Nenhum item na lista :(",
                      style: TextStyle(fontSize: 30))
                ]))
          : ListView.separated(
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
          leading: purchaseList[index].image != ""
              ? Image.memory(
                  ImageUtils.base64ToImage(purchaseList[index].image))
              : Image.asset('images/gift_card.png'),
          title: Text("${purchaseList[index].productName}"),
          subtitle: Text("U\$${purchaseList[index].dollarProductPrice.toStringAsFixed(2)}"),
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
    database
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
<<<<<<< HEAD
    purchaseList.removeWhere((item) => item.id == purchase.id);

    _database
        .update(
=======
    database.update(
>>>>>>> f6edd7868245e71d30ce44718576d89af6fb1753
      'purchase',
      purchase.toMap(),
      where: "id = ?",
      whereArgs: [purchase.id],
    ).then((value) {
      setState(() {
        purchaseList.add(purchase);
      });
    });
  }

  deletePerson(int index) {
    database.delete(
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
