import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ushopping/sqlite/model/purchase.dart';
import 'package:flutter_app_ushopping/utils/CustomButton.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_ushopping/utils/ImageUtils.dart';

import 'model/purchase.dart';

class AddPurchase extends StatefulWidget {
  final Purchase purchaseItem;

  const AddPurchase({Key key, this.purchaseItem}) : super(key: key);

  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  CollectionReference statesRefs;

  @override
  void initState() {
    super.initState();

    statesRefs = Firestore.instance.collection("states");
    _loadIofTax();

    if (widget.purchaseItem != null) {
      _purchaseId = widget.purchaseItem.id;
      _productNameController.text = widget.purchaseItem.productName;
      _valueController.text = widget.purchaseItem.dollarProductPrice.toStringAsFixed(2);
      if (widget.purchaseItem.image != "")
        _imageBase64 = widget.purchaseItem.image;
      _dropDownValue = widget.purchaseItem.state;
      _isCard = widget.purchaseItem.isCard == 1;
      _loadStateTax(widget.purchaseItem.state);
      _textAction = "Editar";
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final MoneyMaskedTextController _valueController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  File _image;
  String _dropDownValue;

  String _imageBase64 = "";
  String _textAction = "Cadastrar";
  bool _isCard = false;

  double _iofTax = 0;
  double _stateTax = 0;
  int _purchaseId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_textAction produto"),
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
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
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
                          : _imageBase64 != ""
                              ? Image.memory(
                                  ImageUtils.base64ToImage(_imageBase64))
                              : Image.asset('images/gift_card.png')),
                ),
                SizedBox(height: 16),
                _loadItensDropDown(context),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
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
                  text: _textAction,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      var fullPrice = double.parse(_valueController.text);
                      if (_stateTax != 0) {
                        fullPrice = double.parse(_valueController.text) *
                            (_stateTax / 100 + 1);
                      }

                      if (_isCard) {
                        fullPrice = fullPrice * (_iofTax / 100 + 1);
                      }

                      fullPrice = double.parse(fullPrice.toStringAsFixed(2));

                      Purchase purchase = Purchase(
                          id: _purchaseId != 0 ? _purchaseId : null,
                          productName: _productNameController.text,
                          dollarProductPrice:
                              double.parse(_valueController.text),
                          fullProductPrice: fullPrice,
                          state: _dropDownValue != null ? _dropDownValue : "",
                          image: _image != null
                              ? ImageUtils.imageToBase64(_image)
                              : _imageBase64,
                          isCard: _isCard ? 1 : 0);
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
    PickedFile selectedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    File image = File(selectedFile.path);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    PickedFile selectedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
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
      stream: statesRefs.snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? LinearProgressIndicator()
            : _buildDropDown(snapshot.data.documents);
      },
    );
  }

  Widget _buildDropDown(List<DocumentSnapshot> snapshot) {
    List<DropdownMenuItem> _stateItems = [];
    for (int i = 0; i < snapshot.length; i++) {
      DocumentSnapshot snap = snapshot[i];
      _stateItems.add(DropdownMenuItem(
        child: Text(
          snap.documentID,
        ),
        value: "${snap.documentID}",
      ));
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
        value: this._dropDownValue);
  }

  void _dropDownItemSelected(String newState) {
    setState(() {
      this._dropDownValue = newState;
      _loadStateTax(newState);
    });
  }
  
  void _loadIofTax(){
    Firestore.instance
        .collection("ioftax")
        .getDocuments()
        .then((value) => this._iofTax = value.documents[0].documentID as double);
  }

  void _loadStateTax(String state) {
    statesRefs
        .document(state)
        .get()
        .then((value) => this._stateTax = value.data['tax']);
  }
}
