import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<bool>(
      stream: presenter.isValidFormStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: (snapshot.data == false)
              ? null
              : () {
                  presenter.auth();
                },
          child: Text(
            'Entrar'.toUpperCase(),
          ),
        );
      },
    );
  }
}
