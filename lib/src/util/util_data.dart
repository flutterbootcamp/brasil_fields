import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Classe para manipular datas.
class UtilData {
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (!_initialized) {
      initializeDateFormatting('pt_BR');
      _initialized = true;
    }
  }

  /// Validar se uma data está no formato brasileiro `DDMMAAAA`.
  static bool validarData(String data) {
    return removeCaracteres(data).length == 8;
  }

  /// Remove caracteres não numéricos da string informada.
  static String removeCaracteres(String data) {
    final novaData = StringBuffer();

    for (var index in data.runes) {
      final numero = int.tryParse(String.fromCharCode(index));
      if (numero != null) {
        novaData.write(numero);
      }
    }

    return novaData.toString();
  }

  /// Retorna a data informada no formato `DD/MM/AAAA`
  static String obterDataDDMMAAAA(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.yMd('pt_BR').format(dateTime);
  }

  /// Retorna a data informada no formato `MM/AAAA`
  static String obterDataMMAAAA(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.yM('pt_BR').format(dateTime);
  }

  /// Retorna a data informada no formato `DD/MM`
  static String obterDataDDMM(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Md('pt_BR').format(dateTime);
  }

  /// Retorna a hora informada no formato `hh:mm:ss`
  static String obterHoraHHMMSS(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Hms('pt_BR').format(dateTime);
  }

  /// Retorna a hora informada no formato `hh:mm`
  static String obterHoraHHMM(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Hm('pt_BR').format(dateTime);
  }

  /// Retorna o mes de uma data. Informar data no formato `DDMMAAAA`
  static int? obterMes(String data) {
    final dataLimpa = removeCaracteres(data);

    if (validarData(dataLimpa)) {
      final novaData = StringBuffer();
      novaData.write(dataLimpa[2]);
      novaData.write(dataLimpa[3]);
      final dataInt = int.tryParse(novaData.toString());
      if (dataInt != null) {
        return dataInt;
      } else {
        throw Exception('Nao foi possível obter o mes da data $data');
      }
    } else {
      throw Exception('Nao foi possível obter o mes da data $data');
    }
  }

  /// Retorna o dia de uma data. Informar data no formato `DDMMAAAA`
  static int? obterDia(String data) {
    final dataLimpa = removeCaracteres(data);
    if (validarData(dataLimpa)) {
      final novaData = StringBuffer();
      novaData.write(dataLimpa[0]);
      novaData.write(dataLimpa[1]);

      final dataInt = int.tryParse(novaData.toString());

      if (dataInt != null) {
        return dataInt;
      } else {
        throw Exception('Nao foi possível obter o dia da data $data');
      }
    } else {
      throw Exception('Nao foi possível obter o dia da data $data');
    }
  }

  /// Retorna um objeto [DateTime] de acordo com a data informada.
  ///
  /// Informar a string `data` no formato `DD/MM/AAAA`
  static DateTime obterDateTime(String data) {
    _ensureInitialized();
    return DateFormat.yMd("pt_BR").parse(data);
  }

  /// Retorna um objeto [DateTime] de acordo com a data informada.
  ///
  /// Informar a string `data` no formato `DD/MM/AAAA HH:MM`
  static DateTime obterDateTimeHora(String data) {
    _ensureInitialized();
    return DateFormat.yMd("pt_BR").add_jm().parse(data);
  }

  /// Retorna um objeto [DateTime] de acordo com a data informada.
  ///
  /// Informar a string `data` no formato `HH:MM`
  static DateTime obterDateTimeHoraMinuto(String data) {
    _ensureInitialized();
    return DateFormat.jm("pt_BR").parse(data);
  }
}
