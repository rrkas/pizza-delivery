import 'package:flutter/material.dart';

class WidgetUtils {
  static InputDecoration customInputDecoration(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
    );
    final style = TextStyle(color: Theme.of(context).primaryColor);
    return InputDecoration(
      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
      filled: true,
      border: border,
      disabledBorder: border,
      enabledBorder: border,
      errorBorder: border,
      focusedBorder: border,
      focusedErrorBorder: border,
      suffixStyle: style,
      counterStyle: style,
      errorStyle: style,
      helperStyle: style,
      hintStyle: style,
      labelStyle: style,
      prefixStyle: style,
    );
  }
}
