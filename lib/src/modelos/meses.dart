/// Reúne os nomes e os números dos meses do ano.
class Meses {
  /// Nomes dos meses, de janeiro a dezembro.
  static const List<String> listaMeses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  /// Associa cada nome ao número do mês, de 1 a 12.
  static Map<String, int> mapaMeses = const {
    'Janeiro': 1,
    'Fevereiro': 2,
    'Março': 3,
    'Abril': 4,
    'Maio': 5,
    'Junho': 6,
    'Julho': 7,
    'Agosto': 8,
    'Setembro': 9,
    'Outubro': 10,
    'Novembro': 11,
    'Dezembro': 12,
  };
}
