import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/components/error_snackbar.dart';

import '../../components/components.dart';
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
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              showSpinnerDialog(
                context,
                "Aguarde...",
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
                errorMesage,
              );
            }
          },
        );

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              Headline01(
                text: 'login'.toUpperCase(),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<String?>(
                          stream: widget.presenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                  label: const Text('E-mail'),
                                  icon: const Icon(Icons.email),
                                  errorText: (snapshot.data?.isEmpty == true)
                                      ? null
                                      : snapshot.data),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: widget.presenter.validateEmail,
                            );
                          }),
                      StreamBuilder<String?>(
                          stream: widget.presenter.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                  label: const Text('Senha'),
                                  icon: const Icon(Icons.lock),
                                  errorText: (snapshot.data?.isEmpty == true)
                                      ? null
                                      : snapshot.data),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onChanged: widget.presenter.validatePassword,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 8,
                        ),
                        child: StreamBuilder<bool>(
                            stream: widget.presenter.isValidFormStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: (snapshot.data == false)
                                    ? null
                                    : () {
                                        widget.presenter.auth();
                                      },
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Criar conta'.toUpperCase()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
