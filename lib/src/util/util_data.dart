// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/date_symbol_data_local.dart';
// ignore: import_of_legacy_library_into_null_safe
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

    data.runes.forEach((index) {
      final numero = int.tryParse(String.fromCharCode(index));
      if (numero != null) {
        novaData.write(numero);
      }
    });

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
  static int? getMes(String data) {
    final dataLimpa = removeCaracteres(data);
    if (validarData(dataLimpa)) {
      final novaData = StringBuffer();
      novaData.write(dataLimpa[2]);
      novaData.write(dataLimpa[3]);

      return int?.tryParse(novaData.toString());
    } else {
      throw Exception('Nao foi possível obter o mes da data $data');
    }
  }

  /// Retorna o mes de uma data. Informar data no formato `DDMMAAAA`
  static int? getDia(String data) {
    final dataLimpa = removeCaracteres(data);
    if (validarData(dataLimpa)) {
      final novaData = StringBuffer();
      novaData.write(dataLimpa[0]);
      novaData.write(dataLimpa[1]);

      return int?.tryParse(novaData.toString());
    } else {
      throw Exception('Nao foi possível obter o dia da data $data');
    }
  }
}
