import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.developer_mode_sharp,
                  color: Colors.black87,
                  size: 32,
                ),
                Text('Login')
              ],
            ),
            Form(
              child: Column(
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
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Entrar'.toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Criar conta'.toUpperCase()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
