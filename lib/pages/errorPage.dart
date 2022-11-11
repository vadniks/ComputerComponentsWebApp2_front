
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cursov_front/consts.dart';
import 'package:cursov_front/widgets/basicAppBar.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  String? _getArgument(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args !is String) return null;
    else return args;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [
      TextButton(
        onPressed: () => Navigator.of(context).pushNamed(routeHome),
        child: const Text(home)
      )
    ]),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '$errorOccurred:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontStyle: FontStyle.italic
          ),
        ),
        Text(
          _getArgument(context) ?? unknownError,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        )
      ]
    )
  );
}
