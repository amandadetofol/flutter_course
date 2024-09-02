import 'package:flutter/material.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('E-mail'),
                        icon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Senha'),
                        icon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                        bottom: 8,
                      ),
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text('Entrar'.toUpperCase()),
                      ),
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
