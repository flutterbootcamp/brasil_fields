import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brasil Fields',
      theme: ThemeData(primarySwatch: Colors.green),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text('Formatters'),
                  icon: Icon(Icons.keyboard),
                ),
                Tab(
                  child: Text('Datas'),
                  icon: Icon(Icons.calendar_today),
                ),
                Tab(
                  icon: Icon(Icons.smart_display),
                  child: Text('Padrões'),
                ),
              ],
            ),
            title: const Text('Brasil Fields'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              children: [
                ListView(
                  children: [
                    RowFormatters(
                      label: 'CEP',
                      formatter: CepInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'CPF',
                      formatter: CpfInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'CNPJ',
                      formatter: CnpjInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'CPF/CNPJ',
                      formatter: CpfOuCnpjFormatter(),
                    ),
                    RowFormatters(
                      label: 'Telefone',
                      formatter: TelefoneInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'Data',
                      formatter: DataInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'Hora',
                      formatter: HoraInputFormatter(),
                    ),
                    RowFormatters(
                        label: 'Real',
                        formatter: RealInputFormatter(
                          moeda: true,
                        )),
                    RowFormatters(
                        label: 'Combustível',
                        formatter: CentavosInputFormatter(
                            moeda: true, casasDecimais: 3)),
                    RowFormatters(
                        label: 'Centavos', formatter: CentavosInputFormatter()),
                    RowFormatters(
                        label: 'Real', formatter: RealInputFormatter()),
                    RowFormatters(
                      label: 'Peso',
                      formatter: PesoInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'Altura',
                      formatter: AlturaInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'Cartão Bancário',
                      formatter: CartaoBancarioInputFormatter(),
                    ),
                    RowFormatters(
                      label: 'Validade Cartão Bancário',
                      formatter: ValidadeCartaoInputFormatter(),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(label: Text('Placa Veículo')),
                      inputFormatters: [PlacaVeiculoInputFormatter()],
                    )
                  ],
                ),
                const Text('Em breve'),
                const Text('Em breve'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowFormatters extends StatelessWidget {
  final String label;
  final TextInputFormatter formatter;
  const RowFormatters({
    Key key,
    this.label,
    this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text(label)),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        formatter,
      ],
    );
  }
}
