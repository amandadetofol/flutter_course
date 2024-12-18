// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/components/error_snackbar.dart';
import 'package:flutter_course/lib/ui/helpers/errors/ui_error.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/i18n/resources.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({
    super.key,
    required this.presenter,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<LoginPresenter>(
      create: (_) => widget.presenter,
      child: Scaffold(
        body: Builder(builder: (context) {
          widget.presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading ?? false) {
                showSpinnerDialog(
                  context,
                  R.translations.loading,
                );
              } else {
                hideDialog(context);
              }
            },
          );

          widget.presenter.mainErrorStream.listen(
            (errorMesage) {
              if (errorMesage != null) {
                showErrorSnackBar(
                  context,
                  errorMesage.description,
                );
              }
            },
          );

          widget.presenter.navigateToStream.listen(
            (page) {
              if (page?.isNotEmpty == true) {
                Get.offAllNamed(page!);
              }
            },
          );

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
                          const EmailInput(),
                          const PasswordInput(),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 32,
                              bottom: 8,
                            ),
                            child: SignInButton(),
                          ),
                          TextButton(
                            onPressed: widget.presenter.goToSignUp,
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
      ),
    );
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
