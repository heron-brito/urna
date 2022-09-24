
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
  }

  _loadSharePrefs() async {
    final prefs = await SharedPreferences.getInstance();
        //imprime todos os dados
    final keys = prefs.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
       prefsMap[key] = prefs.get(key);
    }
    print(prefsMap);
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
              height: 100,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Divider(
                    height: 100,
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
                    height: 100,
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