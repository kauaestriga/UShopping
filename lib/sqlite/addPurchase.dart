import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ushopping/sqlite/model/purchase.dart';
import 'package:flutter_app_ushopping/utils/CustomButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_ushopping/utils/ImageUtils.dart';

import 'model/purchase.dart';

class AddPurchase extends StatefulWidget {
  final Purchase purchaseItem;

  const AddPurchase ({ Key key, this.purchaseItem }): super(key: key);
  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {

  @override
  void initState() {
    super.initState();

    if (widget.purchaseItem != null) {
      _productNameController.text = widget.purchaseItem.productName;
      _valueController.text = widget.purchaseItem.fullProductPrice.toString();
      if(widget.purchaseItem.image != "")
        _image = File.fromRawPath(ImageUtils.base64ToImage(widget.purchaseItem.image));
      _isCard = widget.purchaseItem.isCard == 1;
    }
  }

  final _formKey = GlobalKey<FormState>();
  File _image;

  String _dropDownValue;
  // var _states = ['Alabama', 'Alaska', 'New York', 'Washington'];
  // List<DropdownMenuItem> _stateItems = [];

  bool _isCard = false;
  double _iofTax = 6.38;
  double _stateTax = 0;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar produto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Nome do produto",
                      labelText: "Nome do produto"),
                  controller: _productNameController,
                  validator: (value) {
                    return value.isEmpty ? "Insira o nome do produto" : null;
                  },
                ),
                SizedBox(height: 16),
                Container(
                  child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(_image,
                                  width: 400,
                                  height: 200,
                                  fit: BoxFit.fitWidth),
                            )
                          : Image.asset('images/gift_card.png')),
                ),
                SizedBox(height: 16),
                _loadItensDropDown(context),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Valor (U\$)",
                                  labelText: "Valor (U\$)"),
                              controller: _valueController,
                              validator: (value) {
                                return value.isEmpty ? "Insira um valor" : null;
                              })),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Cartão?", style: TextStyle(fontSize: 16)),
                            Switch(
                              value: _isCard,
                              onChanged: (value) {
                                setState(() {
                                  _isCard = value;
                                });
                              },
                              activeTrackColor: Colors.red,
                              activeColor: Colors.red,
                            )
                          ],
                        ),
                      )
                    ]),
                SizedBox(height: 16),
                CustomButton(
                  text: "Cadastrar",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      var fullPrice = double.parse(_valueController.text);
                      if (_stateTax != 0) {
                        fullPrice = double.parse(_valueController.text) * (_stateTax / 100 + 1);
                      }

                      if (_isCard) {
                        fullPrice = fullPrice * (_iofTax / 100 + 1);
                      }

                      Purchase purchase = Purchase(
                        productName: _productNameController.text,
                        dollarProductPrice: double.parse(_valueController.text),
                        fullProductPrice: fullPrice,
                        state: _dropDownValue != null ? _dropDownValue : "",
                        image: _image != null ? ImageUtils.imageToBase64(_image) : "",
                        isCard: _isCard ? 1 : 0
                      );
                      Navigator.pop(context, purchase);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imgFromCamera() async {
    PickedFile selectedFile = await ImagePicker().getImage(source: ImageSource.camera);
    File image = File(selectedFile.path);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    PickedFile selectedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(selectedFile.path);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _loadItensDropDown(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("states").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) LinearProgressIndicator();

        return _buildDropDown(snapshot.data.documents);
      },
    );
  }

  Widget _buildDropDown(List<DocumentSnapshot> snapshot) {
    List<DropdownMenuItem> _stateItems = [];
    for(int i=0; i < snapshot.length; i++) {
      DocumentSnapshot snap = snapshot[i];
      _stateItems.add(
          DropdownMenuItem(
            child: Text(
              snap.documentID,
            ),
            value: "${snap.documentID}",
          )
      );
    }

    return DropdownButton(
        iconEnabledColor: Colors.red,
        isExpanded: true,
        underline: Container(
          height: 2,
          color: Colors.redAccent,
        ),
        items: _stateItems,
        hint: new Text("Escolha o estado"),
        onChanged: (newState) {
          _dropDownItemSelected(newState);
        },
        value: this._dropDownValue
    );
  }

  void _dropDownItemSelected(String newState) {
    setState(() {
      this._dropDownValue = newState;
    });
  }

  // _loadItensDropDown() {
  //   return DropdownButton<String>(
  //       iconEnabledColor: Colors.red,
  //       isExpanded: true,
  //       underline: Container(
  //         height: 2,
  //         color: Colors.redAccent,
  //       ),
  //       items: _states.map((String dropDownStringItem) {
  //         return DropdownMenuItem<String>(
  //           value: dropDownStringItem,
  //           child: Text(dropDownStringItem),
  //         );
  //       }).toList(),
  //       hint: new Text("Escolha o estado"),
  //       onChanged: (String newState) {
  //         _dropDownItemSelected(newState);
  //         setState(() {
  //           this._dropDownValue = newState;
  //         });
  //       },
  //       value: _dropDownValue);
  // }
}
