
import 'package:cursov_front/consts.dart';

import '../widgets/basicAppBar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  NavigatorState get _navigator => Navigator.of(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [
      TextButton(
        onPressed: () => _navigator.pop(),
        child: const Text(home)
      )
    ]),
  );
}
