
import 'pages/adminPage.dart';
import 'pages/errorPage.dart';
import 'pages/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'pages/aboutPage.dart';
import 'pages/homePage.dart';
import 'pages/selectPage.dart';
import 'consts.dart';

void main() => runApp(const App());

// /data/flutter/bin/flutter run -d web-server --web-renderer canvaskit --web-port 8000
// /data/flutter/bin/flutter build web --web-renderer canvaskit --base-href / --dart2js-optimization O4
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appName,
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: Colors.cyan,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      dialogBackgroundColor: darkSecondaryColor,
      snackBarTheme: const SnackBarThemeData(backgroundColor: darkSecondaryColor),
      listTileTheme: const ListTileThemeData(tileColor: Colors.transparent),
      cardColor: Colors.black,
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
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        surface: darkSecondaryColor,
        onSecondary: darkSecondaryColor
      ).copyWith(background: Colors.black)
    ),
    home: const HomePage(),
    initialRoute: routeHome,
    routes: {
      routeAbout : (context) => const AboutPage(),
      routeSelect : (context) => const SelectPage(),
      routeError : (context) => const ErrorPage(),
      routeLogin : (context) => const LoginPage(),
      routeAdmin : (context) => const AdminPage()
    },
  );
}
