import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPurchase extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar compra"),
      ),
      body: Center(
        child: Text("Tela para adicionar novos itens"),
      ),
    );
  }
}