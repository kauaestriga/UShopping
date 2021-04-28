import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/purchase.dart';

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
     openDatabase(
        join(await getDatabasesPath(), 'purchase_database.db'),
        onCreate: (db, version) {
        return db.execute("CREATE TABLE purchase(id INTEGER PRIMARY KEY, productName TEXT, dollarProductPrice REAL, realProductPrice REAL, image TEXT)",
         );
        },
        version: 1
      ).then((db) {
        setState(() {
          _database = db;
        });
      readAll();
    });
  }
  readAll() async {
      final List<Map<String, dynamic>> maps = await
      _database.query('purchase');
      purchaseList = List.generate(maps.length, (i) {
        
      return Purchase (
        id: maps[i]['id'],
        productName: maps[i]['productName'],
        dollarProductPrice: maps[i]['dollarProductPrice'],
        realProductPrice: maps[i]['realProductPrice'],
        image: maps[i]['image']
      );
    });
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
      body: ListView.separated(
      itemCount: purchaseList.length,
      itemBuilder: (context , index) => buildListItem(index, context) ,
      separatorBuilder: (context , index) => 
        Divider(
          height: 1,
        ),
     ),
     floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "/addPurchase"),
      ),
    );
  }

  Widget buildListItem(int index, BuildContext context){
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
            onTap: (){ 
              Navigator. pushNamed(context, "/addPurchase");
            },
            onLongPress: (){
              deletePerson(index);
            },
          ),
        )  ,
      );
  }

  deletePerson(int index) {
    _database.delete('purchase', where: "id = ?", whereArgs: [purchaseList[index].id],
  ).then((value) {
    setState(() {
      purchaseList.removeAt(index);
    });
  });
  }
}