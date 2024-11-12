import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/ui_error.dart';
import '../../../helpers/i18n/resources.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError?>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              label: Text(R.translations.email),
              icon: const Icon(Icons.email),
              errorText:
                  (snapshot.data == null) ? null : snapshot.data?.description,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
