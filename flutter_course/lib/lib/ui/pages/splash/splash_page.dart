import 'package:flutter/material.dart';
import 'package:flutter_course/lib/ui/components/components.dart';
import 'package:flutter_course/lib/ui/pages/splash/splash.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.checkAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.navigateToStream.listen((pageRoute) {
          if (pageRoute.isNotEmpty == true) {
            Get.offAllNamed(pageRoute);
          }
        });

        return const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            SizedBox(
              height: 50,
            ),
            Headline01(
              text: '4 Devs',
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      }),
    );
  }
}
