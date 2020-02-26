import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preferences extends StatelessWidget {
  Preferences(String value) {
    _textField = TextEditingController(text: value);
  }

  TextEditingController _textField;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_textField.value);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Preferences'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textField,
                  enabled: true,
                  maxLength: 2,
                  autovalidate: true,
                  initialValue: '5',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: '時間（分：1～99）を入力してください。',
                      hintText: '例（5）',
                      icon: Icon(Icons.edit),
                      fillColor: Colors.white),
                  validator: (String value) {
                    if (value.length == 0 || int.parse(value) < 1) {
                      return '1～99の値を入力してください。';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
