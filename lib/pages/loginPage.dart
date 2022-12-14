
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import '../interop/user.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import 'package:flutter/material.dart';
import '../util.dart';
import 'package:http/http.dart' as http;

import 'errorPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _registration = false;
  final _controllers = List<TextEditingController>.generate(
    2, (index) => TextEditingController(), growable: false
  );
  var _authorized = false;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthorization();

    final dynamic args = getArgs(context);
    if (args != null && args is! bool) throw ArgumentError(null);
    _registration = args ?? false;
  }

  Future<void> _checkAuthorization() async {
    final result = await authorizedAsAny;
    setState(() => _authorized = result);
  }

  Map<String, dynamic> _makeMap() => {
    nameC : _controllers[0].text,
    passwordC : _controllers[1].text
  };

  Future<bool> _login() async => (await http.post(
    '$baseUrl/login'.uri,
    body: _makeMap()
  )).statusCode == 200;

  Future<bool> _register() async => (await http.post(
    '$baseUrl/register'.uri,
    headers: jsonHeader,
    body: jsonEncode(_makeMap())
  )).statusCode == 200;

  void _afterRegistration() {
    setState(() => _registration = false);
    _clear();
    showSnackBar(context, registrationSuccessful);
  }

  Future<void> _performAction() async {
    var areAllFilled = true;
    for (final i in _controllers) areAllFilled &= i.text.isNotEmpty;

    if (!areAllFilled) {
      showSnackBar(context, notAllFieldsFilled);
      return;
    }

    if (!_registration ? await _login() : await _register())
      !_registration ? _navigator.pop() : _afterRegistration();
    else
      showSnackBar(context, !_registration ? wrongCredentials : nameExists);
  }

  void _clear() { for (final i in _controllers) i.clear(); }
  
  @override
  Widget build(BuildContext context)
  => _authorized ? const ErrorPage(error: alreadyAuthorized) : Scaffold(
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
            hint: login2
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
