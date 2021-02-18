import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Classe para manipular datas.
class UtilData {
  /// Validar se uma data está no formato brasileiro `DDMMAAAA`.
  static bool validarData(String data) {
    return removeCaracteres(data).length == 8;
  }

  /// Converter o formato brasileiro `DDMMAAAA` para UTC `AAAAMMDD`.
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

  /// Retornar a data informada no formato `DD/MM/AAAA`
  static String obterDataDDMMAAAA(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.yMd('pt_BR').format(dateTime);
  }

  /// Retornar a data informada no formato `MM/AAAA`
  static String obterDataMMAAAA(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.yM('pt_BR').format(dateTime);
  }

  /// Retornar a data informada no formato `DD/MM`
  static String obterDataDDMM(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.Md('pt_BR').format(dateTime);
  }

  /// Retornar a hora informada no formato `hh:mm:ss`
  static String obterHoraHHMMSS(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.Hms('pt_BR').format(dateTime);
  }

  /// Retornar a hora informada no formato `hh:mm`
  static String obterHoraHHMM(DateTime dateTime) {
    initializeDateFormatting();
    return DateFormat.Hm('pt_BR').format(dateTime);
  }

  /// Retornar o mês de uma data, informada no formato `DD/MM/AAAA`
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
        throw Exception('Nao foi possível obter o mês da data $data');
      }
    } else {
      throw Exception('Nao foi possível obter o mês da data $data');
    }
  }

  /// Retornar o dia de uma data, informada no formato `DD/MM/AAAA`
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
}
