import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Utilitários para formatar e extrair partes de datas.
class UtilData {
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (!_initialized) {
      initializeDateFormatting('pt_BR');
      _initialized = true;
    }
  }

  /// Retorna `true` se [data] contiver exatamente oito dígitos.
  ///
  /// Ignora os demais caracteres; não verifica se a data existe.
  static bool validarData(String data) {
    return removeCaracteres(data).length == 8;
  }

  /// Retorna apenas os dígitos de [data].
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

  /// Formata [dateTime] como `DD/MM/AAAA`.
  static String obterDataDDMMAAAA(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.yMd('pt_BR').format(dateTime);
  }

  /// Formata [dateTime] como `MM/AAAA`.
  static String obterDataMMAAAA(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.yM('pt_BR').format(dateTime);
  }

  /// Formata [dateTime] como `DD/MM`.
  static String obterDataDDMM(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Md('pt_BR').format(dateTime);
  }

  /// Formata [dateTime] como `HH:mm:ss` no horário de 24 horas.
  static String obterHoraHHMMSS(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Hms('pt_BR').format(dateTime);
  }

  /// Formata [dateTime] como `HH:mm` no horário de 24 horas.
  static String obterHoraHHMM(DateTime dateTime) {
    _ensureInitialized();
    return DateFormat.Hm('pt_BR').format(dateTime);
  }

  /// Extrai o mês de [data] no formato `DDMMAAAA`.
  ///
  /// Ignora a pontuação e não verifica se o mês existe.
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
        throw Exception('Não foi possível obter o mes da data $data');
      }
    } else {
      throw Exception('Não foi possível obter o mes da data $data');
    }
  }

  /// Extrai o dia de [data] no formato `DDMMAAAA`.
  ///
  /// Ignora a pontuação e não verifica se o dia existe.
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
        throw Exception('Não foi possível obter o dia da data $data');
      }
    } else {
      throw Exception('Não foi possível obter o dia da data $data');
    }
  }

  /// Interpreta [data] no formato `DD/MM/AAAA` como [DateTime].
  static DateTime obterDateTime(String data) {
    _ensureInitialized();
    return DateFormat.yMd("pt_BR").parse(data);
  }

  /// Interpreta [data] no formato `DD/MM/AAAA HH:mm` como [DateTime].
  static DateTime obterDateTimeHora(String data) {
    _ensureInitialized();
    return DateFormat.yMd("pt_BR").add_jm().parse(data);
  }

  /// Interpreta [data] no formato `HH:mm` como [DateTime].
  static DateTime obterDateTimeHoraMinuto(String data) {
    _ensureInitialized();
    return DateFormat.jm("pt_BR").parse(data);
  }
}
