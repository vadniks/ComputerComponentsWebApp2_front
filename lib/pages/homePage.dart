
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

  _makeTextField(TextEditingController controller, String hint) => SizedBox(
    width: 500,
    child: TextFormField(
      keyboardType: TextInputType.text,
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

  void _onSubmitClick() => showModalBottomSheet(
    context: context,
    builder: (context) => Column(children: [
      const Divider(
        height: 1,
        thickness: 1,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
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
                  color: Colors.white70
                )
              )
            ]
          ),
        )
      ),
      _makeTextField(_submitControllers[0], firstName),
      _makeTextField(_submitControllers[1], lastName),
      _makeTextField(_submitControllers[2], phoneNumber),
      _makeTextField(_submitControllers[3], address),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextButton(
          onPressed: () => _performSubmit(),
          child: const Text(
            submit,
            style: TextStyle(fontSize: 18),
          )
        )
      )
    ])
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
        onPressed: () {},
        child: const Text(home),
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
          onPressed: () => _clearSelection(),
          child: const Text(clearSelection)
        ),
        TextButton(
          onPressed: () => _onSubmitClick(),
          child: const Text(submitOrder)
        )
      ],
    ),
    bottomNavigationBar: const BasicBottomBar()
  );
}
