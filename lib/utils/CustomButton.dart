import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.text, this.onPressed});

  final GestureTapCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Colors.red,
        splashColor: Colors.redAccent,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text.toUpperCase(),
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onPressed: onPressed);
  }
}
