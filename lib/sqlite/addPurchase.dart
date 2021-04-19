import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPurchase extends StatefulWidget {
  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  File _image;

  String _dropDownValue;
  var _states = ['Alabama', 'Alaska', 'New York', 'Washington'];

  bool isCard = false;

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
                _loadItensDropDown(),
                Row(
                    // mainAxisSize: MainAxisSize.max,
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
                              value: isCard,
                              onChanged: (value) {
                                setState(() {
                                  isCard = value;
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

  _loadItensDropDown() {
    return DropdownButton<String>(
        iconEnabledColor: Colors.red,
        isExpanded: true,
        underline: Container(
          height: 2,
          color: Colors.redAccent,
        ),
        items: _states.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        hint: new Text("Escolha o estado"),
        onChanged: (String newState) {
          _dropDownItemSelected(newState);
          setState(() {
            this._dropDownValue = newState;
          });
        },
        value: _dropDownValue);
  }

  void _dropDownItemSelected(String newState) {
    setState(() {
      this._dropDownValue = newState;
    });
  }
}
