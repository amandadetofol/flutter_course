// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/headline01.dart';
import '../../components/login_header.dart';
import '../../helpers/i18n/resources.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter presenter;

  const SignUpPage({
    super.key,
    required this.presenter,
  });

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Provider<SignUpPresenter>(
        create: (_) => widget.presenter,
        child: Scaffold(
          body: Builder(builder: (context) {
            return GestureDetector(
              onDoubleTap: _hideKeyboard,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginHeader(),
                    Headline01(
                      text: R.translations.login.toUpperCase(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            NameInput(),
                            EmailInput(),
                            PasswordInput(),
                            PasswordConfirmationInput(),
                            SignUpButton(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
