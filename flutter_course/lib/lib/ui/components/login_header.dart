import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColorLight,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: const [
          BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 5,
              color: Colors.black45)
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
      margin: const EdgeInsets.only(
        bottom: 32,
      ),
      child: const Padding(
        padding: EdgeInsets.all(48),
        child: Icon(
          Icons.developer_mode_sharp,
          color: Colors.white,
          size: 120,
        ),
      ),
    );
  }
}
