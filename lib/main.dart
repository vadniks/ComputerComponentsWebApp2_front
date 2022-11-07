
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'pages/aboutPage.dart';
import 'pages/homePage.dart';
import 'consts.dart';

void main() => runApp(const App());

// ~/flutter/bin/flutter run -d web-server
// ~/flutter/bin/flutter build web --web-renderer canvaskit --base-href /
class App extends StatelessWidget {
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
      dialogBackgroundColor: darkSecondaryColor,
      snackBarTheme: const SnackBarThemeData(backgroundColor: darkSecondaryColor),
      listTileTheme: const ListTileThemeData(tileColor: Colors.transparent),
      cardColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        surface: darkSecondaryColor,
        onSecondary: darkSecondaryColor
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSecondaryColor,
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
    initialRoute: routeHome,
    routes: {
      routeAbout : (context) => const AboutPage()
    },
  );
}
