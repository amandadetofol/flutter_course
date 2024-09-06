import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            label: const Text('E-mail'),
            icon: const Icon(Icons.email),
            errorText: (snapshot.data?.isEmpty == true) ? null : snapshot.data,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
