import 'package:flutter/services.dart';

/// Formata o valor do campo com a mascara °C (ex: 10,8)
class TemperaturaInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 3;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;

    if (newTextLength > maxLength) {
      return oldValue;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();
    switch (newTextLength) {
      case 2:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 1) + ',');
        if (newValue.selection.end >= 2) selectionIndex++;
        break;
      case 3:
        newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ',');
        if (newValue.selection.end >= 3) selectionIndex++;
        break;
    }

    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}