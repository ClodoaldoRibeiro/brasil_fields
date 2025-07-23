import 'package:flutter/services.dart';
import 'package:brasil_fields/src/interfaces/compoundable_formatter.dart';

class CnpjAlfanumericoInputFormatter extends TextInputFormatter
    implements CompoundableFormatter {
  @override
  int get maxLength => 14;

  static final _alphanumericRegex = RegExp(r'[A-Z0-9]');
  static final _digitRegex = RegExp(r'\d');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawText = newValue.text.toUpperCase();

    // Filtra o texto: primeiras 12 posições aceitam letras e números, últimas 2 só números
    final filtered = StringBuffer();
    int rawCursorPosition = 0;

    for (int i = 0, cursor = 0; i < rawText.length && cursor < maxLength; i++) {
      final char = rawText[i];
      if (cursor < 12) {
        if (_isAlphanumeric(char)) {
          filtered.write(char);
          cursor++;
          if (i < newValue.selection.baseOffset) rawCursorPosition++;
        }
      } else {
        if (_isDigit(char)) {
          filtered.write(char);
          cursor++;
          if (i < newValue.selection.baseOffset) rawCursorPosition++;
        }
      }
    }

    final cleanText = filtered.toString();
    final formatted = _applyMask(cleanText);

    // Calcula nova posição do cursor com base nos caracteres e a máscara
    int newCursorPosition = rawCursorPosition;
    if (newCursorPosition >= 2) newCursorPosition++;
    if (newCursorPosition >= 5) newCursorPosition++;
    if (newCursorPosition >= 8) newCursorPosition++;
    if (newCursorPosition >= 12) newCursorPosition++;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, formatted.length),
      ),
    );
  }

  String _applyMask(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('/');
      if (i == 12) buffer.write('-');
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  bool _isAlphanumeric(String char) => _alphanumericRegex.hasMatch(char);

  bool _isDigit(String char) => _digitRegex.hasMatch(char);
}
