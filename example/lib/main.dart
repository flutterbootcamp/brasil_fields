import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brasil Fields',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Brasil Fields'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TextFormField(
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 50),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
