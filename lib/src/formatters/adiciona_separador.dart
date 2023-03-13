String adicionarSeparador(String texto) {
  var valorFinal = "";
  var pointCount = 0;
  for (var i = texto.length - 1; i > -1; i--) {
    if (pointCount == 3) {
      valorFinal = ".$valorFinal";
      pointCount = 0;
    }
    pointCount = pointCount + 1;
    valorFinal = texto[i] + valorFinal;
  }

  return valorFinal;
}
