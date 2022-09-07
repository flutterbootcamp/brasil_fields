import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Classe para manipular datas.
class UtilData {
  /// Validar se uma data está no formato brasileiro `DDMMAAAA`.
  static bool validarData(String data) {
    return removeCaracteres(data).length == 8;
  }

  /// Converte o formato brasileiro `DDMMAAAA` para UTC `AAAAMMDD`.
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
    initializeDateFormatting();
    return DateFormat.yMd('pt_BR').format(dateTime);
  }

  /// Retorna a data informada no formato `MM/AAAA`
  static String obterDataMMAAAA(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.yM('pt_BR').format(dateTime);
  }

  /// Retorna a data informada no formato `DD/MM`
  static String obterDataDDMM(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.Md('pt_BR').format(dateTime);
  }

  /// Retorna a hora informada no formato `hh:mm:ss`
  static String obterHoraHHMMSS(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.Hms('pt_BR').format(dateTime);
  }

  /// Retorna a hora informada no formato `hh:mm`
  static String obterHoraHHMM(DateTime dateTime) {
    initializeDateFormatting();
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

  /// Retorna o mes de uma data. Informar data no formato `DDMMAAAA`
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
  /// Informar a String `data` no formato `DD/MM/AAAA`
  static DateTime obterDateTime(String data) {
    final dataLimpa = removeCaracteres(data);
    if (validarData(dataLimpa)) {
      final dia = dataLimpa.substring(0, 2);
      final mes = dataLimpa.substring(2, 4);
      final ano = dataLimpa.substring(4, 8);
      return DateTime(int.parse(ano), int.parse(mes), int.parse(dia));
    } else {
      throw Exception('Nao foi possível obter o dia da data $data');
    }
  }
}
