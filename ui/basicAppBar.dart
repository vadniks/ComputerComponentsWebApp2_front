
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'consts.dart';

class BasicAppBar extends AppBar {
  final List<Widget> buttons;

  BasicAppBar({super.key, required this.buttons});

  @override
  List<Widget>? get actions => buttons;

  @override
  Widget? get leading => Padding(
    padding: const EdgeInsets.only(left: 5),
    child: SvgPicture.asset(
      appIcon,
      width: 50,
      height: 50,
    )
  );

  @override
  Widget? get title => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          appName,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          appSince,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white60
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            appSlogan,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.white60
            ),
          ),
        )
      ]
    ),
  );
}
