import 'package:flutter/services.dart';

class TlInputFormatters {
  static final List<TextInputFormatter> onlyAllowAlphabets = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
  ];

  static final List<TextInputFormatter> onlyAllowNumbers = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];

  static final List<TextInputFormatter> onlyAllowAlphabetsAndSpaces = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ];

  static final List<TextInputFormatter> onlyAllowAlphanumeric = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  ];

  static final List<TextInputFormatter> onlyAllowDecimalNumbers = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.contains('.') && newValue.text.split('.').length > 2) {
        return oldValue;
      }
      return newValue;
    }),
  ];

  static final List<TextInputFormatter> toUpperCase = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text.toUpperCase());
    }),
  ];

  static final List<TextInputFormatter> toLowerCase = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text.toLowerCase());
    }),
  ];

  static final List<TextInputFormatter> onlyAllowAlphabetAndNumber = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  ];

  static final List<TextInputFormatter> onlyAllowDate = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      String newText = newValue.text;
      if (newText.length > 10) return oldValue;

      if (newText.length == 2 || newText.length == 5) {
        if (!newText.endsWith('-')) {
          newText += '-';
        }
      }

      if (newText.length > 10) {
        return oldValue;
      }

      if (newText.isNotEmpty &&
          !RegExp(r'^\d{1,2}\/?\d{0,2}\/?\d{0,4}$').hasMatch(newText)) {
        return oldValue;
      }

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }),
  ];
}
