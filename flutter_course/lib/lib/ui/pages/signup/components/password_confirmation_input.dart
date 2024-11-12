import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class PasswordConfirmationInput extends StatelessWidget {
  const PasswordConfirmationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(R.translations.passwordConfirmation),
        icon: const Icon(Icons.lock),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
    );
  }
}
