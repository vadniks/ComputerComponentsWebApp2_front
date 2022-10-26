
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const _darkSecondaryColor = Color(0xFF0F0F0F);

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: Colors.cyan,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      dialogBackgroundColor: _darkSecondaryColor,
      snackBarTheme: const SnackBarThemeData(backgroundColor: _darkSecondaryColor),
      listTileTheme: const ListTileThemeData(tileColor: Colors.transparent),
      cardColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        surface: _darkSecondaryColor,
        onSecondary: _darkSecondaryColor
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSecondaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      ),
      // textButtonTheme: TextButtonThemeData(style: ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all(Colors.blue),
      //   textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))
      // ))
    ),
    home: const HomePage(),
  );
}
