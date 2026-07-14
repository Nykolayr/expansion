import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';

/// Поле пароля с переключателем видимости — единый вид для auth и профиля.
class GamePasswordField extends StatefulWidget {
  const GamePasswordField({
    required this.controller,
    this.labelText,
    this.helperText,
    this.onChanged,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<GamePasswordField> createState() => _GamePasswordFieldState();
}

class _GamePasswordFieldState extends State<GamePasswordField> {
  var _obscured = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: IconButton(
          tooltip: _obscured ? loc.authPasswordToggleShow : loc.authPasswordToggleHide,
          onPressed: () => setState(() => _obscured = !_obscured),
          icon: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        ),
      ),
    );
  }
}
