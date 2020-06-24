import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BrasilFields());

class BrasilFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brasil Fields',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BrasilFieldsApp(),
    );
  }
}

class BrasilFieldsApp extends StatefulWidget {
  @override
  BrasilFieldsState createState() => BrasilFieldsState();
}

class BrasilFieldsState extends State<BrasilFieldsApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Brasil Fields'),
      ),
      body: _homeWidgets[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.format_shapes),
            title: Text('Formatters'),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            title: Text('Modelos'),
          ),
        ],
      ),
    );
  }

  final List<Widget> _homeWidgets = [
    const Formatters(),
    SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinhaModelos(
                text: 'Estados', listaOpcoes: Estados.listaEstados.toList()),
            const SizedBox(height: 16),
            LinhaModelos(text: 'Meses', listaOpcoes: Meses.listaMeses.toList()),
            const SizedBox(height: 16),
            LinhaModelos(
                text: 'Semana', listaOpcoes: Semana.listaDiasSemana.toList()),
            const SizedBox(height: 16),
            LinhaModelos(
                text: 'Regioes', listaOpcoes: Regioes.listaRegioes.toList()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  ];
}

class Formatters extends StatefulWidget {
  const Formatters({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FormattersState();
}

class FormattersState extends State<Formatters> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinhaFormatter(
              text: 'CPF',
              formatter: CpfInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'CNPJ',
              formatter: CnpjInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'CEP',
              formatter: CepInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Moeda',
              formatter: RealInputFormatter(),
              controller: null,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Centavos',
              formatter: RealInputFormatter(centavos: true),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Telefone',
              formatter: TelefoneInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Data',
              formatter: DataInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Hora',
              formatter: HoraInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Cartão',
              formatter: CartaoBancarioInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Validade',
              formatter: ValidadeCartaoInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Altura',
              formatter: AlturaInputFormatter(),
              controller: null,
            ),
            const SizedBox(height: 16),
            LinhaFormatter(
              text: 'Peso',
              formatter: PesoInputFormatter(),
              controller: null,
            ),
          ],
        ),
      ),
    );
  }
}

class LinhaFormatter extends StatelessWidget {
  final String text;
  final TextInputFormatter formatter;
  final TextEditingController controller;
  const LinhaFormatter({
    Key key,
    @required this.text,
    @required this.formatter,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 4.5,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              formatter,
            ],
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class LinhaModelos extends StatefulWidget {
  final String text;
  final List<String> listaOpcoes;
  const LinhaModelos({Key key, @required this.text, @required this.listaOpcoes})
      : super(key: key);
  State createState() => LinhaModelosState();
}

class LinhaModelosState extends State<LinhaModelos> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 4.5,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton(
            items: widget.listaOpcoes.map((String opcao) {
              return DropdownMenuItem<String>(
                value: opcao,
                child: Text(opcao),
              );
            }).toList(),
            isExpanded: true,
            hint: Text(widget.text),
            onChanged: (selecionado) {
              print(selecionado);
            },
          ),
        ),
      ],
    );
  }
}
