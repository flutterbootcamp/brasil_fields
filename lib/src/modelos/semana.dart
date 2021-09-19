/// Possui a lista com os dias da semana.
///
/// `listaDiasUteis` lista com os dias úteis (seg à sex).
/// `mapaDiasUteis` mapa com os dias úteis.
/// `listaDiasUteisAbvr` lista com os dias úteis abreviados.
/// `mapaDiasUteisAbvr` lista com os dias úteis abreviados.
/// `listaDiasSemana` lista com os todos os dias da semana.
/// `listaDiasSemanaOrdenada` lista com todos os dias da semana (dom à sáb).
///
class Semana {
  static const List<String> listaDiasUteis = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
  ];

  static Map<String, int> mapaDiasUteis = const {
    'Segunda-Feira': 1,
    'Terça-Feira': 2,
    'Quarta-Feira': 3,
    'Quinta-Feira': 4,
    'Sexta-Feira': 5,
  };

  static List<String> listaDiasUteisAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  static Map<String, int> mapaDiasUteisAbvr = const {
    'Segunda': 1,
    'Terça': 2,
    'Quarta': 3,
    'Quinta': 4,
    'Sexta': 5,
  };
  static const List<String> listaDiasSemana = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domingo'
  ];

  static const List<String> listaDiasSemanaAbvr = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  static Map<String, int> mapaDiasSemanaOrdenada = const {
    'Domingo': 1,
    'Segunda-Feira': 2,
    'Terça-Feira': 3,
    'Quarta-Feira': 4,
    'Quinta-Feira': 5,
    'Sexta-Feira': 6,
    'Sábado': 7,
  };

  static List<String> listaDiasSemanaOrdenada = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  static Map<String, int> mapaDiasSemanaOrdenadaAbvr = const {
    'Domingo': 1,
    'Segunda': 2,
    'Terça': 3,
    'Quarta': 4,
    'Quinta': 5,
    'Sexta': 6,
    'Sábado': 7,
  };
}
