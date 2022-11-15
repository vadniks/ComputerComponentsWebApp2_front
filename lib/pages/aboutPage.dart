
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BasicAppBar(trailings: [TextButton(
        onPressed: Navigator.of(context).pop,
        child: const Text(home))]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: BasicWindow(
            titleWidgets: [Text(
              aboutApp,
              style: TextStyle(fontSize: screenWidth * 0.015)
            )],
            content: SingleChildScrollView(child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                text: aboutText,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70
                )
              )
            )),
            footerWidgets: defaultFooter,
            padding: const EdgeInsets.only(
              left: 50,
              top: 50,
              right: 50
            )
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10
                ),
                child: SvgPicture.asset(
                  hardwareIcon,
                  width: screenWidth * 0.075,
                  color: Colors.white70
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10
                ),
                child: SvgPicture.asset(
                  qualityIcon,
                  width: screenWidth * 0.125,
                  color: Colors.white70
                )
              )
            ]
          )
        ]
      ),
      bottomNavigationBar: const BasicBottomBar()
    );
  }
}
