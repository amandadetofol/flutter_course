import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../helpers/i18n/resources.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
                label: Text(R.translations.name),
                icon: const Icon(Icons.person),
                errorText: (snapshot.data == null)
                    ? null
                    : snapshot.data?.description),
            keyboardType: TextInputType.name,
            obscureText: true,
            onChanged: presenter.validateName,
          );
        });
  }
}
