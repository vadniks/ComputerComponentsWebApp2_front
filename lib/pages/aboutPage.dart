
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () => Navigator.of(context).pushNamed(routeHome),
      child: const Text(home))]
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: BasicWindow(
          titleWidgets: const [Text(
            aboutApp,
            style: TextStyle(fontSize: 20)
          )],
          content: RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              text: aboutText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70
              ),
            ),
          ),
          footerWidgets: const []
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                hardwareIcon,
                width: 100,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                qualityIcon,
                width: 175,
                height: 175,
              ),
            )
          ]
        )
      ]
    ),
    bottomNavigationBar: const BasicBottomBar()
  );
}

/*
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              hardwareIcon,
              width: 100,
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              qualityIcon,
              width: 175,
              height: 175,
            ),
          )
        ]
      )
*/