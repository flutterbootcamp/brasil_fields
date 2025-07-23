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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBarView(
              children: [
                ListView(
                  children: [
                    DigitsOnlyTextField(
                      label: 'CEP',
                      formatter: CepInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'CPF',
                      formatter: CpfInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'CNPJ',
                      formatter: CnpjInputFormatter(),
                    ),
                    const AlphanumericTextField(
                      label: 'Novo CNPJ',
                      formatter: CnpjAlfanumericoInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'CPF/CNPJ',
                      formatter: CpfOuCnpjFormatter(),
                    ),
                    AlphanumericTextField(
                      label: 'CPF/Novo CNPJ',
                      formatter: CpfOuCnpjAlfanumericoFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Telefone',
                      formatter: TelefoneInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Data',
                      formatter: DataInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Hora',
                      formatter: HoraInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'KM',
                      formatter: KmInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                        label: 'Centavos', formatter: CentavosInputFormatter()),
                    DigitsOnlyTextField(
                        label: 'Centavos + moeda',
                        formatter: CentavosInputFormatter(moeda: true)),
                    DigitsOnlyTextField(
                        label: 'Centavos + 3 decimais',
                        formatter: CentavosInputFormatter(casasDecimais: 3)),
                    DigitsOnlyTextField(
                        label: 'Centavos + 3 decimais + moeda',
                        formatter: CentavosInputFormatter(
                            casasDecimais: 3, moeda: true)),
                    DigitsOnlyTextField(
                        label: 'Real', formatter: RealInputFormatter()),
                    DigitsOnlyTextField(
                        label: 'Real + moeda',
                        formatter: RealInputFormatter(moeda: true)),
                    DigitsOnlyTextField(
                      label: 'Peso',
                      formatter: PesoInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Altura',
                      formatter: AlturaInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Cartão Bancário',
                      formatter: CartaoBancarioInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Validade Cartão Bancário',
                      formatter: ValidadeCartaoInputFormatter(),
                    ),
                    AlphanumericTextField(
                      label: 'Placa Veículo',
                      formatter: PlacaVeiculoInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'Temperatura',
                      formatter: TemperaturaInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'IOF',
                      formatter: IOFInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'NCM',
                      formatter: NCMInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'NUP',
                      formatter: NUPInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'CEST',
                      formatter: CESTInputFormatter(),
                    ),
                    DigitsOnlyTextField(
                      label: 'CNS',
                      formatter: CNSInputFormatter(),
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

class DigitsOnlyTextField extends StatelessWidget {
  final String label;
  final TextInputFormatter formatter;

  const DigitsOnlyTextField({
    super.key,
    required this.label,
    required this.formatter,
  });

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

class AlphanumericTextField extends StatelessWidget {
  final String label;
  final TextInputFormatter formatter;

  const AlphanumericTextField({
    super.key,
    required this.label,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text(label)),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
        formatter,
      ],
    );
  }
}
