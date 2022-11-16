
import 'dart:convert';
import 'consts.dart';
import 'package:flutter/material.dart';

Image decodeImage(String base64) => Image.memory(const Base64Decoder().convert(base64));

dynamic getArgs(BuildContext context) => ModalRoute.of(context)!.settings.arguments;

List<Widget> get defaultFooter => const [SizedBox(width: 25, height: 25)];

makeTextField({
  required TextEditingController controller,
  required String hint,
  bool isNumeric = false,
  bool isPassword = false
}) => SizedBox(
  width: 500,
  child: TextFormField(
    keyboardType: !isNumeric ? TextInputType.text : TextInputType.number,
    obscureText: isPassword,
    maxLines: 1,
    cursorColor: Colors.white70,
    controller: controller,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 14
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38)
    ),
  ),
);

extension Additionals on String? {

  String get value => this ?? nullString;

  bool containsIgnoreCase(String value)
  => this == null ? false : this!.toLowerCase().contains(value.toLowerCase());
}
