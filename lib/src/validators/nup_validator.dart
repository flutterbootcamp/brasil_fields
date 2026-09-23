/// Valida e formata números processuais no padrão definido pelo CNJ.
class NUPValidator {
  static const stripRegex = r'[^\d]';

  /// Retorna `true` se [nup] tem formato e dígitos verificadores válidos.
  ///
  /// Remove caracteres não numéricos antes da validação quando
  /// [stripBeforeValidation] é `true`.
  static bool isValid(String? nup, {bool stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      nup = strip(nup);
    }

    if (nup == null || nup.isEmpty) {
      return false;
    }

    if (nup.length != 20) {
      return false;
    }

    if (!RegExp(r'^\d{20}$').hasMatch(nup)) {
      return false;
    }

    final checkDigit = _checkDigit(nup);
    return nup.substring(7, 9) == checkDigit.toString();
  }

  /// Remove caracteres não numéricos do número processual.
  static String strip(String? nup) {
    final regExp = RegExp(stripRegex);
    nup = nup ?? '';

    return nup.replaceAll(regExp, '');
  }

  // Calcula os dígitos verificadores pelo módulo 97, conforme a norma do CNJ:
  // https://atos.cnj.jus.br/files/compilado23285720221017634de539229ab.pdf
  static String _checkDigit(String nup) {
    final sequential = nup.substring(0, 7);
    final year = nup.substring(9, 13);
    final segment = nup[13];
    final court = nup.substring(14, 16);
    final origin = nup.substring(16);

    final r1 = int.parse(sequential) % 97;
    final r2 = int.parse('$r1$year$segment$court') % 97;
    final r3 = int.parse('$r2${origin}00') % 97;

    final checkDigit = 98 - r3;
    return checkDigit.toString().padLeft(2, '0');
  }

  /// Formata o NUP com a máscara `NNNNNNN-DD.AAAA.J.TR.OOOO`.
  static String format(String nup) {
    final regExp = RegExp(r'^(\d{7})(\d{2})(\d{4})(\d{1})(\d{2})(\d{4})$');

    return strip(nup).replaceAllMapped(
      regExp,
      (Match m) => '${m[1]}-${m[2]}.${m[3]}.${m[4]}.${m[5]}.${m[6]}',
    );
  }
}
