import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/signup/signup_presenter.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/ui_error.dart';
import '../../../helpers/i18n/resources.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
                label: Text(R.translations.passwordConfirmation),
                icon: const Icon(Icons.lock),
                errorText: (snapshot.data == null)
                    ? null
                    : snapshot.data?.description),
            keyboardType: TextInputType.text,
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
