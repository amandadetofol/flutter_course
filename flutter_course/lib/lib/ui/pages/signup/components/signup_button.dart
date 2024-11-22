import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/helpers/i18n/i18n.dart';
import 'package:flutter_course/lib/ui/pages/signup/signup_presenter.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<bool?>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: (snapshot.data == false)
              ? null
              : () {
                  presenter.signUp();
                },
          child: Text(
            R.translations.login.toUpperCase(),
          ),
        );
      },
    );
  }
}
