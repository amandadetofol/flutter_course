import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(R.translations.password),
        icon: const Icon(Icons.lock),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
    );
  }
}
