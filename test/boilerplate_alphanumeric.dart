import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget boilerplateAlphaNumeric(
    TextInputFormatter inputFormatter, TextEditingController textController) {
  return MaterialApp(
    home: MediaQuery(
      data: const MediaQueryData(size: Size(320, 480)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: TextField(
            controller: textController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
              inputFormatter,
            ],
          ),
        ),
      ),
    ),
  );
}
