/// Reúne nomes e índices dos dias úteis e dos dias da semana.
class Semana {
  /// Nomes completos dos dias úteis, de segunda a sexta-feira.
  static const List<String> listaDiasUteis = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
  ];

  /// Associa os nomes completos dos dias úteis aos índices de 1 a 5.
  static const Map<String, int> mapaDiasUteis = {
    'Segunda-Feira': 1,
    'Terça-Feira': 2,
    'Quarta-Feira': 3,
    'Quinta-Feira': 4,
    'Sexta-Feira': 5,
  };

  /// Nomes dos dias úteis sem o sufixo `-Feira`, de segunda a sexta.
  static const List<String> listaDiasUteisAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  /// Associa os nomes sem `-Feira` aos índices de 1 a 5.
  static const Map<String, int> mapaDiasUteisAbvr = {
    'Segunda': 1,
    'Terça': 2,
    'Quarta': 3,
    'Quinta': 4,
    'Sexta': 5,
  };

  /// Nomes completos dos dias da semana, de segunda-feira a domingo.
  static const List<String> listaDiasSemana = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domingo',
  ];

  /// Nomes dos dias da semana sem o sufixo `-Feira`, de segunda a domingo.
  static const List<String> listaDiasSemanaAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  /// Associa os nomes completos aos índices de 1 a 7, a partir de domingo.
  static const Map<String, int> mapaDiasSemanaOrdenada = {
    'Domingo': 1,
    'Segunda-Feira': 2,
    'Terça-Feira': 3,
    'Quarta-Feira': 4,
    'Quinta-Feira': 5,
    'Sexta-Feira': 6,
    'Sábado': 7,
  };

  /// Nomes dos dias da semana sem o sufixo `-Feira`, de domingo a sábado.
  static const List<String> listaDiasSemanaOrdenada = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  /// Associa os nomes sem `-Feira` aos índices de 1 a 7, a partir de domingo.
  static const Map<String, int> mapaDiasSemanaOrdenadaAbvr = {
    'Domingo': 1,
    'Segunda': 2,
    'Terça': 3,
    'Quarta': 4,
    'Quinta': 5,
    'Sexta': 6,
    'Sábado': 7,
  };
}
