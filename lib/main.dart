// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urna/pagina_admin.dart';
import 'package:urna/pagina_cadidato.dart';
// import './dbprovider.dart';
// import './eleitores_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  // List<String> emails = ['a@a.com', ];
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   // title: 'Urna Eletrônica',
    //   // theme: ThemeData(
    //   //   primarySwatch: Colors.blue,
    //   // ),
    //   body: const MyHomePage(title: 'Cadastro'),
    //   // debugShowCheckedModeBanner: false
    // );
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
  // var email_list =  <String>['heronmb100@gmail.com', 'alanis.bbrum100@gmail.com', 'agatha.bbrum100@gmail.com'];
  // final prefs = await SharedPreferences.getInstance();

  final emailController = TextEditingController();
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // EleitoresDbProvider eleitorDb = EleitoresDbProvider();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //     title: Center(child: Text(widget.title)),
    //   ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: FloatingActionButton.small(
                  backgroundColor: Colors.grey.shade200,
                  onPressed: () {onPressedAdmin(context);}),
              ),
             ]
          ),
          Column(
            children: [Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              <Widget>[
                // Divider( 
                //   height: 50, 
                //   thickness: 0.1),
                const Text(
                  'Eleitor, para votar é necessário preencher o seu e-mail',
                  style: TextStyle(fontSize: 25.0 ),              
                ),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: TextField(
                    controller: myController,
                  ),
                ),
                // const SizedBox(
                //   width: 400,
                //   height: 100,
                //   child: TextField(
                //     controller: emailController,
                //     obscureText: true,
                //     textAlign: TextAlign.left,
                //     decoration: InputDecoration(
                //       border: InputBorder.none,
                //       hintText: 'PLEASE ENTER YOUR EMAIL',
                //       hintStyle: TextStyle(color: Colors.grey),
                //     ),
                //   )),
                TextButton(
                  onPressed: onPressedVotar, 
                  child: const Text(
                    'Votar !',
                    style: TextStyle(
                        color: Color.fromARGB(255, 200, 200, 200),
                        fontSize: 25.0 ),              
                  ),
                  style: 
                    TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        // primary: const Color.fromARGB(255, 200, 200, 200),
                        primary: Colors.white,
                        // backgroundColor: const Color.fromARGB(255, 20, 20, 20),
                        backgroundColor: Colors.grey.shade800,
                        // onPrimary: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontStyle: FontStyle.italic
                        ),
                      ), 
                  ),
              ],
            ),
            ],
          ),
        ],
      ),
    );
  }

  onPressedAdmin(BuildContext context) {
    print('onPressedAdmin');
    //  sleep(Duration(seconds:1)); 
     showAlertDialog1(context);
    //  sleep(Duration(seconds:1)); 
    //  Navigator.push(
    //      context,
    //      MaterialPageRoute(builder: (context) => const AdminPage() ),
    //  );
  }


  showAlertDialog1(BuildContext context) 
  { 
    // final myController2 = TextEditingController();
    print('showAlertDialog1');

    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        print('codigo: ' + myController2.text);
        // if (myController2 == '02082005') { 
        if (myController2.text == '111111') { 
            print('código correto');
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPage() ),);
        } else {
            print('código errado');
            Navigator.of(context, rootNavigator: true).pop();
        }
       },
    );

    Widget cancelaButton = TextButton(
      child: const Text("Cancela"),
      onPressed: () { 
        // Navigator.of(context).pop();
        Navigator.of(context, rootNavigator: true).pop();
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp() ),  );
      }
    );

    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: const Text("Area restrita aos mesários."),
      // content: Text("Area restrita aos mesários."),
      contentPadding: const EdgeInsets.all(16.0),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: myController2,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Código' ),
                  // labelText: 'Full Name', hintText: 'eg. John Smith'),
            ),
          )
        ],
      ),
      actions: [
        cancelaButton,
        okButton,
      ],
      
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
    
  Future<void> onPressedVotar() async {
    // SQLlite
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
    List<String>? email_list = prefs.getStringList('emails');
    if (email_list  == null ) { 
      email_list = [];
      } 

    // await prefs.setInt('counter', 10);
    // await prefs.setStringList('emails', <String>['Earth', 'Moon', 'Sun']);
    // final int? counter = prefs.getInt('counter');

    await prefs.setStringList('emails', email_list! );


    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(myController.text);

    if (emailValid) {
       final List<String>? emails = prefs.getStringList('emails');
      //  print('counter: ' + counter.toString());
       print('email_list: ' + emails.toString());
       print('email: ' + myController.text);

       if(email_list.contains(myController.text)){
           print('${myController.text} is present in the list $email_list');
           final snackBar = SnackBar(
                   content: const Text('O voto deste eleitor já foi computador!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
       } else {
           print('${myController.text} is not present in the list $email_list');
           email_list.add(myController.text);
           await prefs.setStringList('emails', email_list );
           sleep(Duration(seconds:1)); 
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => const PaginaCandidato() ),
           );
       }


    } else {
       print('email inválido: ${myController.text}');
       final List<String>? emails = prefs.getStringList('emails');
       print('email_list: $emails');
       // ignore: prefer_const_constructors
       final snackBar = SnackBar(
               content: const Text('Preencha o e-mail corretamente!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

  }
}

