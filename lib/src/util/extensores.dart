import 'package:intl/intl.dart';

extension BrasiLFields on double {
  /// Converte um valor double para centavos com o símbolo de real brasileiro
  String get obterCentavos => '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).toInt().toString()}';

  /// Converte um valor double para centavos sem o símbolo de real brasileiro
  ///
  String get obterCentavosSemSimbolo => obterCentavos.replaceAll('R\$ ', '');

  /// Converte um valor double para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String obterReal([int fracaoDigitos = 2]) => NumberFormat.currency(locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$').format(this);

  /// Converte um valor double para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String obterRealSemSimbolo([int fracaoDigitos = 2]) => obterReal(fracaoDigitos).replaceAll('R\$ ', '');
}

extension BrasilFields on int {
  /// Converte um valor inteiro para centavos com o símbolo de real brasileiro
  String get obterCentavos => '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).toInt().toString()}';

  /// Converte um valor inteiro para centavos sem o símbolo de real brasileiro
  ///
  String get obterCentavosSemSimbolo => obterCentavos.replaceAll('R\$ ', '');

  /// Converte um valor inteiro para real
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String obterReal([int fracaoDigitos = 2]) => NumberFormat.currency(locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$').format(this);

  /// Converte um valor inteiro para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String obterRealSemSimbolo([int fracaoDigitos = 2]) => obterReal(fracaoDigitos).replaceAll('R\$ ', '');
}
