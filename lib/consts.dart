
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

const darkSecondaryColor = Color(0xFF0F0F0F);

const appName = 'PC Components Shop',
  appSince = 'Since 2022',
  appSlogan = 'Build your own PC with PC Configurator online and free! Choose any components you like and buy them!',
  home = 'Home',
  about = 'About',
  componentsList = 'PC Components List',
  totalCost = 'Total cost: ',
  clearSelection = 'Clear selection',
  submitOrder = 'Submit order',
  copyright = 'Copyright (C) 2022 | All Rights Reserved',
  aboutApp = 'About PC Components Shop',
  componentsSelection = 'PC Components Selection',
  searchByTitle = 'Search by title',
  empty = 'Empty',
  errorOccurred = 'An error has occurred',
  unknownError = 'Unknown error',
  noParametersProvidedError = 'No parameters have been provided to the page',
  submit = 'Submit',
  defaultCost = '0\$',
  firstName = 'First name',
  lastName = 'Last name',
  phoneNumber = 'Phone number',
  address = 'Address',
  loginPanel = 'Login panel',
  registrationPanel = 'Registration panel',
  login = 'Login',
  password = 'Password',
  register = 'Register',
  clear = 'Clear',
  aboutText = '''We are Leading Company
Provide our customers with superior products and services at the most reasonable rates available. At the time of company formation in 2022, our core business was as a computer parts reseller. We initiated our company with the philosophy that “We refuse to compromise quality for profit” and have not since changed that guiding principle.

The quality of our custom built computers speak for themselves. They are reliable because we use brand name components which equals no headaches. PC Configurator sales and services focus on selling the best possible product at the best possible price. On a local level, PC Configurator’s exists to provide computer hardware and services. PC Configurator’s is very competitive on a national level in terms of price, quality and services. PC Configurator’s major market extends to all those with access to the internet and a web browser.''';

const appIcon = 'pc_icon.svg',
  svgExtension = '.svg',
  hardwareIcon = 'hwr_ico.svg',
  qualityIcon = 'qlt_ico.svg';

const routeHome = '/',
  routeAbout = '/about',
  routeSelect = '/select',
  routeError = '/error',
  routeLogin = '/login';

const fetchAmount = 8;

const baseUrl = 'http:localhost:8080',
  selectComponentUrl = '$baseUrl/select';

Image decodeImage(String base64) =>
    Image.memory(const Base64Decoder().convert(base64));

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
