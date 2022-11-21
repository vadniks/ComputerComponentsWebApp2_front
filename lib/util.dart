
import 'package:http/http.dart' as http;
import 'consts.dart';
import 'package:flutter/material.dart';

Image loadImage(String image, {required double width, required double height}) => Image.network(
  imageUrl + image + jpgExtension,
  width: width,
  height: height,
);

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

Future<bool> get authorizedAsUser async
=> (await http.get(Uri.parse('$baseUrl/authorizedU'))).statusCode == 200;

Future<bool> get authorizedAsAdmin async
=> (await http.get(Uri.parse('$baseUrl/authorizedA'))).statusCode == 200;

Future<bool> get authorizedAsAny async
=> await authorizedAsUser || await authorizedAsAdmin;

void showSnackBar(BuildContext context, String text)
=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
  text,
  style: const TextStyle(color: Colors.white70),
)));

const jsonHeader = {"Content-Type": "application/json"};

extension NullableAdditionals on String? { String get value => this ?? nullString; }

extension Additionals on String {

  bool containsIgnoreCase(String value)
  => toLowerCase().contains(value.toLowerCase());

  Uri get uri => Uri.parse(this);

  String get beforeLast => substring(0, length - 1);
}
