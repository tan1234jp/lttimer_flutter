import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                  return (value.length == 0 || int.parse(value) < 1)
                      ? '1～99の値を入力してください。'
                      : null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
