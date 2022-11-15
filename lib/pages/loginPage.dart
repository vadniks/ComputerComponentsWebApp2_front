
// ignore_for_file: curly_braces_in_flow_control_structures

import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _registration = false;
  final _controllers = List<TextEditingController>.generate(
    2, (index) => TextEditingController(), growable: false
  );

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = getArgs(context);
    if (args != null && args is! bool) throw ArgumentError(null);
    _registration = args ?? false;
  }

  void _performAction() {

  }

  void _clear() { for (final i in _controllers) i.clear(); }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [
      TextButton(
        onPressed: _navigator.pop,
        child: const Text(home)
      ),
      TextButton(
        onPressed: () => setState(() => _registration = !_registration),
        child: !_registration ? const Text(register) : const Text(login)
      )
    ]),
    body: BasicWindow(
      expandContent: false,
      width: 600,
      titleWidgets: [Text(
        !_registration ? loginPanel : registrationPanel,
        style: const TextStyle(fontSize: 20)
      )],
      content: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(children: [
          makeTextField(
            controller: _controllers[0],
            hint: login
          ),
          makeTextField(
            controller: _controllers[1],
            hint: password,
            isPassword: true
          )
        ]),
      ),
      footerWidgets: [
        TextButton(
          onPressed: _performAction,
          child: Text(!_registration ? login : register)
        ),
        TextButton(
          onPressed: _clear,
          child: const Text(clear)
        )
      ],
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
