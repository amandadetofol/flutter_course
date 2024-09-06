import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
              label: const Text('Senha'),
              icon: const Icon(Icons.lock),
              errorText:
                  (snapshot.data?.isEmpty == true) ? null : snapshot.data),
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}
