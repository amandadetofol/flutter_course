import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/helpers/i18n/i18n.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<bool?>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: (snapshot.data == false)
              ? null
              : () {
                  presenter.auth();
                },
          child: Text(
            R.translations.login.toUpperCase(),
          ),
        );
      },
    );
  }
}
