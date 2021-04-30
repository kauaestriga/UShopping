import 'dart:ffi';

class Purchase {
  int id;
  final String productName;
  final double dollarProductPrice;
  final double fullProductPrice;
  final String image;
  final String state;
  final int isCard;

  Purchase(
      {this.id,
      this.productName,
      this.dollarProductPrice,
      this.fullProductPrice,
      this.image,
      this.state,
      this.isCard});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'dollarProductPrice': dollarProductPrice,
      'fullProductPrice': fullProductPrice,
      'image': image,
      'state': state,
      'isCard': isCard
    };
  }
}
