
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../consts.dart';
import '../component.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _selected = List<Component?>.filled(Type.amount, null, growable: false);
  final _submitControllers = List.generate(
    4, (_) => TextEditingController(), growable: false
  );

  NavigatorState get _navigator => Navigator.of(context);

  Future<void> _onItemClick(Type type) async {
    final dynamic result = await _navigator.pushNamed(
      routeSelect,
      arguments: type
    );

    if (result != null && result is! Component) throw ArgumentError(null);
    if (!mounted) return;
    result as Component;

    setState(() => _selected[result.type.index] = result);
  }

  List<Widget> _makeItems() {
    final list = <Widget>[];
    for (final i in Type.types) {
      final component = _selected[i.index];
      list.add(Card(
        margin: const EdgeInsets.all(5),
        child: Material(child: ListTile(
          onTap: () => _onItemClick(i),
          leading: component?.image != null
            ? decodeImage(component!.image!)
            : SvgPicture.asset(
              i.icon + svgExtension,
              width: 50,
              height: 50,
            ),
          title: const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          subtitle: Text(
            component != null ? component.title : i.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            component != null ? component.cost.toString() : defaultCost,
            style: const TextStyle(fontStyle: FontStyle.italic)
          ),
        )),
      ));
    }
    return list;
  }

  void _onSubmitClick() => showModalBottomSheet(
    constraints: const BoxConstraints(maxWidth: 600),
    context: context,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(
          color: darkSecondaryColor,
          spreadRadius: 1,
          offset: Offset(0, 0)
        )]
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
          child: SizedBox(
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  submitOrder,
                  style: TextStyle(fontSize: 20)
                ),
                Text(
                  ' $totalCost${100}', // TODO
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontStyle: FontStyle.italic
                  )
                )
              ]
            ),
          )
        ),
        makeTextField(
          controller: _submitControllers[0],
          hint: firstName
        ),
        makeTextField(
          controller: _submitControllers[1],
          hint: lastName
        ),
        makeTextField(
          controller: _submitControllers[2],
          hint: phoneNumber,
          isNumeric: true
        ),
        makeTextField(
          controller: _submitControllers[3],
          hint: address
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextButton(
            onPressed: _performSubmit,
            child: const Text(
              submit,
              style: TextStyle(fontSize: 18),
            )
          )
        )
      ])
    )
  );

  Future<void> _performSubmit() async {
    // TODO: post request
  }

  Future<void> _clearSelection() async {
    _selected.clear();
    _selected.addAll(List.filled(Type.amount, null, growable: false));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [
      TextButton(
        onPressed: () => _navigator.pushNamed(routeLogin),
        child: const Text(login),
      ),
      TextButton(
        onPressed: () => _navigator.pushNamed(routeAbout),
        child: const Text(about)
      )
    ]),
    body: BasicWindow(
      titleWidgets: const [Text(
        componentsList,
        style: TextStyle(fontSize: 20)
      )],
      content: ListView(children: ListTile.divideTiles(
        tiles: _makeItems(),
        color: Colors.white10
      ).toList()),
      footerWidgets: [
        const Text(
          totalCost,
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: _clearSelection,
          child: const Text(clearSelection)
        ),
        TextButton(
          onPressed: _onSubmitClick,
          child: const Text(submitOrder)
        )
      ],
    ),
    bottomNavigationBar: const BasicBottomBar()
  );
}
