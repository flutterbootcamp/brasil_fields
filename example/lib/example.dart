import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        title: Text('Brasil Fields'),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.format_shapes),
            title: Text('Formatters'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            title: Text('Modelos'),
          ),
        ],
      ),
    );
  }

  final List<Widget> _homeWidgets = [
    Formatters(),
    SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),

        // width: MediaQuery.of(context).size.width / 2.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinhaModelos(
              text: 'Estados',
              listaOpcoes: Estados.listaEstados.toList(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaModelos(
              text: 'Meses',
              listaOpcoes: Meses.listaMeses.toList(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaModelos(
              text: 'Semana',
              listaOpcoes: Semana.listaDiasSemana.toList(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaModelos(
              text: 'Regioes',
              listaOpcoes: Regioes.listaRegioes.toList(),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    ),
  ];
}

class Formatters extends StatelessWidget {
  const Formatters({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        // width: MediaQuery.of(context).size.width / 2.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinhaFormatter(
              text: 'CPF',
              formatter: CpfInputFormatter(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaFormatter(
              text: 'CNPJ',
              formatter: CnpjInputFormatter(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaFormatter(
              text: 'CEP',
              formatter: CepInputFormatter(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaFormatter(
              text: 'Moeda',
              formatter: RealInputFormatter(),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaFormatter(
              text: 'Centavos',
              formatter: RealInputFormatter(centavos: true),
            ),
            SizedBox(
              height: 15,
            ),
            LinhaFormatter(
              text: 'Data',
              formatter: DataInputFormatter(),
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
  const LinhaFormatter({
    Key key,
    @required this.text,
    @required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 4.5,
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
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
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(width: 10),
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
