import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(R.translations.email),
        icon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
