import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            label: const Text('E-mail'),
            icon: const Icon(Icons.email),
            errorText:
                (snapshot.data == null) ? null : snapshot.data?.description,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
