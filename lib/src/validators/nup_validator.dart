class NUPValidator {
  static const stripRegex = r'[^\d]';

  static bool isValid(String? nup, {stripBeforeValidation = true}) {
    if (stripBeforeValidation) {
      nup = strip(nup);
    }

    if (nup == null || nup.isEmpty) {
      return false;
    }

    if (nup.length != 20) {
      return false;
    }

    final checkDigit = _checkDigit(nup);
    return nup.substring(7, 9) == checkDigit.toString();
  }

  static String strip(String? nup) {
    var regex = RegExp(stripRegex);
    nup = nup ?? '';

    return nup.replaceAll(regex, '');
  }

  // Compute the Check Digit (or 'Dígito Verificador (DV)' in PT-BR).
  // You can learn more about the algorithm on [CNJ (pt-br)](https://atos.cnj.jus.br/files/compilado23285720221017634de539229ab.pdf)
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

  static String format(String nup) {
    var regExp = RegExp(r'^(\d{7})(\d{2})(\d{4})(\d{1})(\d{2})(\d{4})$');

    return strip(nup).replaceAllMapped(
        regExp, (Match m) => '${m[1]}-${m[2]}.${m[3]}.${m[4]}.${m[5]}.${m[6]}');
  }

}
