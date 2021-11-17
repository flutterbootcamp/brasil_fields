String adicionarSeparador(String texto) {
  var valorFinal = "";
  var pointCount = 0;
  for (var i = texto.length - 1; i > -1; i--) {
    pointCount = pointCount + 1;
    if (pointCount == 4) {
      valorFinal = "." + valorFinal;
      pointCount = 0;
    }
    valorFinal = texto[i] + valorFinal;
  }

  return valorFinal;
}
