import 'package:intl/intl.dart';

extension BrasiLFields on double {
  /// Converte um valor double para centavos com o símbolo de real brasileiro
  String get paraCentavos => '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).toInt().toString()}';

  /// Converte um valor double para centavos sem o símbolo de real brasileiro
  ///
  String get paraCentavosSemSimbolo => paraCentavos.replaceAll('R\$ ', '');

  /// Converte um valor double para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String paraReal([int fracaoDigitos = 2]) =>
      NumberFormat.currency(locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$').format(this);

  /// Converte um valor double para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String paraRealSemSimbolo([int fracaoDigitos = 2]) => paraReal(fracaoDigitos).replaceAll('R\$ ', '');
}

extension BrasilFields on int {
  /// Converte um valor inteiro para centavos com o símbolo de real brasileiro
  String get paraCentavos => '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).toInt().toString()}';

  /// Converte um valor inteiro para centavos sem o símbolo de real brasileiro
  ///
  String get paraCentavosSemSimbolo => paraCentavos.replaceAll('R\$ ', '');

  /// Converte um valor inteiro para real
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String paraReal([int fracaoDigitos = 2]) =>
      NumberFormat.currency(locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$').format(this);

  /// Converte um valor inteiro para real com o símbolo de real brasileiro
  ///
  /// [fracaoDigitos] define a quantidade de casas após a vírgula
  String paraRealSemSimbolo([int fracaoDigitos = 2]) => paraReal(fracaoDigitos).replaceAll('R\$ ', '');
}
