
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urna/main.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  // List<String> emails = ['a@a.com', 'b@b.com', 'c@c.com', 'a@a.com', 'b@b.com', 'c@c.com', 'a@a.com', 'b@b.com', 'c@c.com' ];
  // List<String> emails = [];  
  List<String> emails = ['a@a.com', ];
  String qtdVotantes = '';
  
  // String get qtd_votantes => emails.length.toString();
  // String qtd_votantes = emails.length.toString();

  void _onPressedGotoHome(BuildContext context) {
     print('_onPressedGotoHome');
     Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Cadastro',) ),
     );
  }

  @override
  void initState() {
    // assert(_debugLifecycleState == _StateLifecycle.created);
    _loadSharePrefs();
    print('emails1: ${emails}');
  }

  _loadSharePrefs() async {
     final prefs = await SharedPreferences.getInstance();
         //imprime todos os dados
     final keys = await prefs.getKeys();
     final prefsMap = Map<String, dynamic>();
     for(String key in keys) {
        print('key {key}');
        prefsMap[key] = prefs.get(key);
     }
     print(prefsMap);
 
     print('prefs.get\(\'emails\'\)');
     print(await prefs.get('emails'));
     print('emails2: ${emails}');
     emails = await  prefs.getStringList('emails') ?? [];
     print('emails3: ${emails}');
    //  List<String> emails = prefs.getStringList('emails') ?? [];
    //  List<String>? emailsTmp = prefs.getStringList('emails');
    //  emails = emailsTmp! ;
    //  emails = prefs.get('emails') as List<String>;
    //  emails = prefs.get('emails') ;
    //  qtdVotantes = emails.length.toString();
    // if (emails != null) {
    //  qtdVotantes = emails.length;
    //  print('qtd eleitores: $qtdVotantes}');

    // }
    //  qtdVotantes = emails.length;
    //  print('qtd eleitores: $qtdVotantes}');
 
  }

  // ignore: non_constant_identifier_names
  _listaVotantes() async{
    print('_listaVotantes');
    await _loadSharePrefs();    
    print('emails: ${emails}');
  }

  _clearPrefs() async{
    // final prefs = await SharedPreferences.getInstance();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              // color: Colors.grey,
              color: const Color.fromRGBO(217, 217, 200, 100)
              ),        
        child: Column(
          children: [
            const Divider(
              height: 50,
              thickness: 0.1,
            ),
            Text( qtdVotantes ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 200,
                    width: 200,
                    child:ListView(
                      children: emails.map((strone){
                      return Container(
                          child: Text(strone),
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          color: Colors.grey.shade100,
                      );
                    }).toList(),
                  )),  

                  const Divider(
                    height: 50,
                    thickness: 0.1,
                  ),
                   TextButton(
                      style: TextButton.styleFrom(
                        primary: const Color.fromARGB(255, 200, 200, 200),
                        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
                        // onPrimary: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontStyle: FontStyle.italic
                        ),
                      ),                    
                      onPressed: (){_listaVotantes();}, 
                      child: const Text(' Lista ')
                   ),                  
                   TextButton(
                      style: TextButton.styleFrom(
                        primary: const Color.fromARGB(255, 200, 200, 200),
                        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
                        // onPrimary: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontStyle: FontStyle.italic
                        ),
                      ),                    
                      onPressed: (){_clearPrefs();}, 
                      child: const Text(' Zerar toda votação ')
                   ),
                  const Divider(
                    height: 50,
                    thickness: 0.1,
                  ),
                   TextButton(
                      style: TextButton.styleFrom(
                        primary: const Color.fromARGB(255, 200, 200, 200),
                        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
                        // onPrimary: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontStyle: FontStyle.italic
                        ),
                      ),                    
                      onPressed: (){_onPressedGotoHome(context);}, 
                      child: const Text(' Voltar a tela inicial ')
                   ),
                  // Divider(
                  //   height: 200,
                  // ),

                  //  IconButton(
                  //   onPressed: (){_onPressedGotoHome(context);}, 
                   // icon: Icon(Icons.abc)),
                ]
                ),
                // ListView(),
          ],
        ),
      )
    );
  }
}