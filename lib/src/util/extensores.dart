import 'package:intl/intl.dart';

extension BrasilFieldsDouble on double {
  /// Converte o valor em reais para centavos com o prefixo `R$ `.
  ///
  /// Arredonda frações para o centavo mais próximo.
  String get obterCentavos =>
      '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).round()}';

  /// Converte o valor em reais para centavos sem o prefixo `R$ `.
  ///
  /// Arredonda frações para o centavo mais próximo.
  String get obterCentavosSemSimbolo => obterCentavos.replaceAll('R\$ ', '');

  /// Formata o valor em reais com o símbolo `R$`.
  ///
  /// [fracaoDigitos] define o número de casas decimais.
  String obterReal([int fracaoDigitos = 2]) => NumberFormat.currency(
          locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$')
      .format(this);

  /// Formata o valor em reais sem o símbolo `R$`.
  ///
  /// [fracaoDigitos] define o número de casas decimais.
  String obterRealSemSimbolo([int fracaoDigitos = 2]) =>
      obterReal(fracaoDigitos).replaceAll('R\$ ', '');
}

extension BrasilFieldsInt on int {
  /// Converte o valor inteiro em reais para centavos com o prefixo `R$ `.
  String get obterCentavos =>
      '${this < 0 ? '-' : ''}R\$ ${(abs() * 100).toInt().toString()}';

  /// Converte o valor inteiro em reais para centavos sem o prefixo `R$ `.
  String get obterCentavosSemSimbolo => obterCentavos.replaceAll('R\$ ', '');

  /// Formata o valor inteiro em reais com o símbolo `R$`.
  ///
  /// [fracaoDigitos] define o número de casas decimais.
  String obterReal([int fracaoDigitos = 2]) => NumberFormat.currency(
          locale: 'pt_BR', decimalDigits: fracaoDigitos, symbol: 'R\$')
      .format(this);

  /// Formata o valor inteiro em reais sem o símbolo `R$`.
  ///
  /// [fracaoDigitos] define o número de casas decimais.
  String obterRealSemSimbolo([int fracaoDigitos = 2]) =>
      obterReal(fracaoDigitos).replaceAll('R\$ ', '');
}
