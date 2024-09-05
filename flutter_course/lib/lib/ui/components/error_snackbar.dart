import 'package:flutter/material.dart';

void showErrorSnackBar(
  BuildContext context,
  String errorMesage,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMesage),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red[900],
    ),
  );
}
