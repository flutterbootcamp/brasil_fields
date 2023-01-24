import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                  icon: Icon(Icons.keyboard),
                  child: Text('Formatters'),
                ),
                Tab(
                  icon: Icon(Icons.calendar_today),
                  child: Text('Datas'),
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
                        label: 'Centavos', formatter: CentavosInputFormatter()),
                    RowFormatters(
                        label: 'Centavos + moeda',
                        formatter: CentavosInputFormatter(moeda: true)),
                    RowFormatters(
                        label: 'Centavos + 3 decimais',
                        formatter: CentavosInputFormatter(casasDecimais: 3)),
                    RowFormatters(
                        label: 'Centavos + 3 decimais + moeda',
                        formatter: CentavosInputFormatter(
                            casasDecimais: 3, moeda: true)),
                    RowFormatters(
                        label: 'Real', formatter: RealInputFormatter()),
                    RowFormatters(
                        label: 'Real + moeda',
                        formatter: RealInputFormatter(moeda: true)),
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
                    ),
                    RowFormatters(
                      label: 'Temperatura',
                      formatter: TemperaturaInputFormatter(),
                    ),
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

  const RowFormatters(
      {super.key, required this.label, required this.formatter});

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
