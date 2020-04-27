class UtilBrasilFields {
  static String removeCaracteres(String valor) {
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }
}
