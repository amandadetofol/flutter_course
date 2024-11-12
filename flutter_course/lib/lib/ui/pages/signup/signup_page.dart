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
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const NameInput(),
                            const EmailInput(),
                            const PasswordInput(),
                            const PasswordConfirmationInput(),
                            TextButton(
                              onPressed: null,
                              child: Text(
                                R.translations.addAccount.toUpperCase(),
                              ),
                            ),
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
