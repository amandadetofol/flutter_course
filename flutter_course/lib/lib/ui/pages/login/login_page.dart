import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        stream: presenter.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                                label: const Text('E-mail'),
                                icon: const Icon(Icons.email),
                                errorText: (snapshot.data?.isEmpty == true)
                                    ? null
                                    : snapshot.data),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter.validateEmail,
                          );
                        }),
                    StreamBuilder<String?>(
                        stream: presenter.passwordErrorStream,
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
                            onChanged: presenter.validatePassword,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                        bottom: 8,
                      ),
                      child: StreamBuilder<bool>(
                          stream: presenter.isValidFormStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed:
                                  (snapshot.data == false) ? null : () {},
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
      ),
    );
  }
}
