import 'dart:ffi';

class Purchase {

int id;
final String productName;
final Double dollarProductPrice;
final Double realProductPrice;
final String image;

Purchase({this.id, this.productName, this.dollarProductPrice, this.realProductPrice, this.image});

Map<String, dynamic> toMap() {
 return {
 'id': id,
 'productName': productName,
 'dollarProductPrice': dollarProductPrice,
 'realProductPrice': realProductPrice,
 'image': image
 };
}
}