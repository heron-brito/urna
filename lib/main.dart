import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urna/pagina_cadidato.dart';
// import './dbprovider.dart';
// import './eleitores_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urna Eletrônica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cadastro'),
      debugShowCheckedModeBanner: false
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // EleitoresDbProvider eleitorDb = EleitoresDbProvider();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          <Widget>[
            const Text(
              'Preencha seu e-mail',
              style: TextStyle(fontSize: 25.0 ),              
            ),
            const SizedBox(
              width: 400,
              height: 100,
              child: TextField()),
            TextButton(
              onPressed: onPressed, 
              child: const Text(
                'Votar !',
                style: TextStyle(fontSize: 25.0 ),              
              )),
          ],
        ),
      ),
    );
  }

  // void onPressed() {
  Future<void> onPressed() async {
    // final eleitor = EleitorModel(
    //   id: 1,
    //   nome: 'Title 1',
    //   email: 'Note 1',
    // );
  
    // await eleitorDb.addItem(eleitor);
    // var eleitores = await eleitorDb.fetchEleitores();
    // print(eleitores[0].email); //Title 1

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', 10);
    await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);

    final int? counter = prefs.getInt('counter');

    final List<String>? items = prefs.getStringList('items');

    sleep(Duration(seconds:1)); 
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PaginaCandidato() ),
  );
  }
}
