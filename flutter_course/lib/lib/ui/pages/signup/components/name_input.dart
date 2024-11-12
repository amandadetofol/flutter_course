import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          label: Text(R.translations.name),
          icon: const Icon(Icons.person),
          errorText: null),
      keyboardType: TextInputType.name,
    );
  }
}
