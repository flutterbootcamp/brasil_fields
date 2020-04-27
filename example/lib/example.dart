import 'package:brasil_fields/brasil_fields.dart';
import 'package:brasil_fields/util/util_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BrasilFields());

class BrasilFields extends StatelessWidget {
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

class Formatters extends StatefulWidget {
  const Formatters({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FormattersState();
}

class FormattersState extends State<Formatters> {
  final cpfController = TextEditingController();
  final cnpjController = TextEditingController();
  final cepController = TextEditingController();
  final moedaController = TextEditingController();
  final centavosController = TextEditingController();
  final telefoneController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();

  @override
  void dispose() {
    cpfController.dispose();
    cnpjController.dispose();
    cepController.dispose();
    moedaController.dispose();
    centavosController.dispose();
    telefoneController.dispose();
    dataController.dispose();
    horaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        // width: MediaQuery.of(context).size.width / 2.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinhaFormatter(
              text: 'CPF',
              formatter: CpfInputFormatter(),
              controller: cpfController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'CNPJ',
              formatter: CnpjInputFormatter(),
              controller: cnpjController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'CEP',
              formatter: CepInputFormatter(),
              controller: cepController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Moeda',
              formatter: RealInputFormatter(),
              controller: moedaController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Centavos',
              formatter: RealInputFormatter(centavos: true),
              controller: centavosController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Telefone',
              formatter: TelefoneInputFormatter(),
              controller: telefoneController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Data',
              formatter: DataInputFormatter(),
              controller: dataController,
            ),
            const SizedBox(
              height: 16,
            ),
            LinhaFormatter(
              text: 'Hora',
              formatter: HoraInputFormatter(),
              controller: horaController,
            ),
            const SizedBox(
              height: 16,
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
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
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
