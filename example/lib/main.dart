import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _textController = TextEditingController();
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
            child: DropdownButton<String>(
              hint: Text('Região'),
              onChanged: (regiaoSelecionada) {
                print(regiaoSelecionada);
              },
              items: Regioes.listaRegioes.map((String regiao) {
                return DropdownMenuItem(
                  value: regiao,
                  child: Text(regiao),
                );
              }).toList(),
            ),
            // child: TextField(
            //   controller: _textController,
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(fontSize: 50),
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly,
            //     CpfInputFormatter(),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
