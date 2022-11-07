
import 'package:flutter/material.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () {},
      child: const Text(home))]
    ),
    body: const BasicWindow(
      titleWidgets: [Text(
        aboutApp,
        style: TextStyle(fontSize: 20)
      )],
      content: Text('data'),
      footerWidgets: [Spacer()],
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
