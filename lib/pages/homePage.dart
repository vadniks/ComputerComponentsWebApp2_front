
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:cursov_front/interop/user.dart';
import 'package:flutter/material.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../consts.dart';
import '../interop/component.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util.dart';
import 'package:http/http.dart' as http;
import '../interop/Selection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selected = List<Component?>.filled(Type.amount, null, growable: false);
  final _submitControllers = List.generate(
    4, (_) => TextEditingController(), growable: false
  );
  var _totalCost = 0, _authorizedAsUser = false, _authorizedAsAdmin = false;
  String? _userName;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void initState() {
    super.initState();
    _fetchEverythingWeNeed();
  }
  
  Future<void> _fetchEverythingWeNeed() async {
    await _checkAuthorization();
    await _fetchUserName();
    await _fetchSelection();
  }

  Future<void> _fetchUserName() async {
    final response = await http.get('$baseUrl/name'.uri);
    setState(() => _userName = response.statusCode == 200 ? response.body : null);
  }

  Future<void> _checkAuthorization() async {
    final user = await authorizedAsUser, admin = await authorizedAsAdmin;
    setState(() {
      _authorizedAsUser = user;
      _authorizedAsAdmin = admin;
      _fetchSelection();
    });
  }

  Future<void> _logOut() async {
    await http.post('$baseUrl/logout'.uri);
    await _fetchEverythingWeNeed();
  }

  Future<Component?> _fetchComponent(int? id) async {
    if (id == null) return null;
    final response = await http.get('$baseUrl/component/$id'.uri);
    return response.statusCode == 200 ? Component.fromJson(jsonDecode(response.body)) : null;
  }

  Future<void> _fetchSelection() async {
    if (!_authorizedAsUser) {
      _resetSelectedList();
      return;
    }

    final response = await http.get('$baseUrl/selected'.uri);
    if (response.statusCode != 200) return;

    final selection = Selection.fromString(response.body);
    final result = [
      await _fetchComponent(selection.cpu),
      await _fetchComponent(selection.mb),
      await _fetchComponent(selection.gpu),
      await _fetchComponent(selection.ram),
      await _fetchComponent(selection.hdd),
      await _fetchComponent(selection.ssd),
      await _fetchComponent(selection.psu),
      await _fetchComponent(selection.fan),
      await _fetchComponent(selection.ca$e),
    ];
    setState(() {
      _selected = result;
      _totalCost = 0;
      for (final i in result) _totalCost += i?.cost ?? 0;
    });
  }

  Future<void> _onItemClick(Type type) async {
    if (!_authorizedAsUser) {
      showSnackBar(context, unauthorizedAsUser);
      return;
    }

    final dynamic result = await _navigator.pushNamed(
      routeSelect,
      arguments: type
    );

    if (result != null && result is! Component) throw ArgumentError(null);
    if (!mounted) return;
    result as Component;

    setState(() {
      _selected[result.type.index] = result;
      _totalCost += result.cost;
    });
    await http.post('$baseUrl/select/${result.id!}'.uri);
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
            ? loadImage(
              component!.image!,
              width: 50,
              height: 50
            )
            : SvgPicture.asset(
              i.icon + svgExtension,
              width: 50,
              height: 50,
            ),
          title: Text(
            component?.title ?? notSelected,
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          subtitle: Text(
            i.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            component != null ? '${component.cost}\$' : defaultCost,
            style: const TextStyle(fontStyle: FontStyle.italic)
          ),
        )),
      ));
    }
    return list;
  }

  void _onSubmitClick()
  => !_authorizedAsUser ? showSnackBar(context, unauthorizedAsUser) : showModalBottomSheet(
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
        const Padding(
          padding: EdgeInsets.only(
            top: 5,
            left: 25,
            right: 25
          ),
          child: Text(
            submitOrder,
            style: TextStyle(fontSize: 20)
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: makeTextField(
            controller: _submitControllers[0],
            hint: firstName
          ),
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
    String? txt(int index) {
      final text = _submitControllers[index].text;
      return text.isEmpty ? null : text;
    }

    String json;
    try { json = jsonEncode({
      firstNameC : txt(0)!,
      lastNameC : txt(1)!,
      phoneC : int.tryParse(txt(2)!)!,
      addressC : txt(3)!
    }); } catch (_) {
      showSnackBar(context, incorrectData);
      return;
    }

    final result = (await http.post(
      '$baseUrl/order'.uri,
      headers: jsonHeader,
      body: json
    )).statusCode == 200;

    if (mounted) {
      _navigator.pop();
      showSnackBar(context, result ? operationSucceeded : operationFailed);
    }
  }

  void _resetSelectedList() => setState(() {
    _selected = List.filled(
      Type.amount,
      null,
      growable: false
    );
    _totalCost = 0;
  });

  void _clearSelection() {
    if (!_authorizedAsUser) {
      showSnackBar(context, unauthorizedAsUser);
      return;
    }
    _resetSelectedList();
    http.post('$baseUrl/clearSelected'.uri);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [
      !_authorizedAsUser && !_authorizedAsAdmin
        ? TextButton(
          onPressed: () => _navigator
            .pushNamed(routeLogin)
            .then((value) => _fetchEverythingWeNeed()),
          child: const Text(login),
        )
        : TextButton(
          onPressed: _logOut,
          child: const Text(logout),
        ),
      if (_authorizedAsAdmin) TextButton(
        onPressed: () => _navigator.pushNamed(routeAdmin),
        child: const Text(administrate)
      ),
      TextButton(
        onPressed: () => _navigator.pushNamed(routeAbout),
        child: const Text(about)
      )
    ]),
    body: BasicWindow(
      titleWidgets: [
        const Text(
          componentsList,
          style: TextStyle(fontSize: 20)
        ),
        if (_userName != null) Padding(
          padding: const EdgeInsets.only(
            right: 5,
            bottom: 5
          ),
          child: Text(
            '$welcome $_userName!',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            )
          ),
        )
      ],
      content: ListView(children: ListTile.divideTiles(
        tiles: _makeItems(),
        color: Colors.white10
      ).toList()),
      footerWidgets: [
        Text(
          '$totalCost$_totalCost\$',
          style: const TextStyle(fontSize: 16),
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
