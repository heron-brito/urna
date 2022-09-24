// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urna/main.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

int algarismo_um = 0;
int algarismo_dois = 0;
bool algarismo_um_pressionado = false;
String candidato = '';
String foto_cadidato ='asset/img/branco.png';

class PaginaCandidato extends StatefulWidget {
  const PaginaCandidato({Key? key}) : super(key: key);

  @override
  State<PaginaCandidato> createState() => _PaginaCandidatoState();
}

class _PaginaCandidatoState extends State<PaginaCandidato> {
  refreshPaginaCandidato() {
    setState(() {
      if ( algarismo_um == 0 && algarismo_dois == 0){
        candidato = '';
        foto_cadidato ='asset/img/branco.png';
      } else if ( algarismo_um == 1 && algarismo_dois == 1){
        candidato = 'Palhaço';
        foto_cadidato ='asset/img/palhaco.webp';
      } else if ( algarismo_um == 2 && algarismo_dois == 2){
        candidato = 'Tirica';
        foto_cadidato ='asset/img/tiririca.webp';
      } else if ( algarismo_um_pressionado == true && algarismo_dois == 0 ){
        candidato = '';
        foto_cadidato ='asset/img/branco.png';
      }
      else {
        candidato = 'Não encontrado';
        foto_cadidato ='asset/img/branco.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(      
      //   title: Center(child: Text('Titulo')),
      // ),
      // body: Row(
    // return Container(
      body: Container(
        decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(16.0),
              // color: Colors.grey,
              color: Color.fromRGBO(217, 217, 200, 100)
              ),        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text(algarismo_um.toString() + algarismo_dois.toString() ),
            LadoEsquerdoSelecao(),
            LadoDireitoCandidato(notifyParent: refreshPaginaCandidato ),          
          ],
        ),
      )
    );  

  }
}

class LadoEsquerdoSelecao extends StatefulWidget {
  const LadoEsquerdoSelecao({
    Key? key,
  }) : super(key: key);

  @override
  State<LadoEsquerdoSelecao> createState() => _LadoEsquerdoSelecaoState();
}

class _LadoEsquerdoSelecaoState extends State<LadoEsquerdoSelecao> {
  // String algarismo_um = '2';
  //candidato = 'Tiririca';

  

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column( //Lado Esquero Número selecionado
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(child: Container(
              height: 500,
              // width: double.infinity,            
              width: 700,            
              decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Colors.grey,
                  ), 
              child: Container(
                height: 300,
                width: 400,            
                decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(1.0),
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(height: 100,),
                        Text('PRESIDENTE', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        Divider(height: 100,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Número:  ', style: TextStyle(fontSize: 25.0)),
                            // Divider(height: 100,),
                            Container(
                                 decoration: BoxDecoration(
                                       border: Border.all(color: Colors.black),
                                     ), 
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  // child: Text('2', style: TextStyle(fontSize: 25.0),),
                                  child: Text(algarismo_um.toString(), style: TextStyle(fontSize: 25.0),),
                                )),
                            VerticalDivider(width: 10,),
                            Container(
                                 decoration: BoxDecoration(
                                       border: Border.all(color: Colors.black),
                                     ), 
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  // child: Text('2', style: TextStyle(fontSize: 25.0),),
                                  child: Text(algarismo_dois.toString(), style: TextStyle(fontSize: 25.0),),
                                )),
                            // Divider(height: 300,),
                            VerticalDivider(width: 200,)
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        Divider(height: 100,),
                        // Text('Tirica      ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        Text( candidato + '      ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                        Divider(height: 50,),
                        Image.asset(foto_cadidato, height: 200.0,),
                        // Image.asset('asset/img/tiririca.webp', height: 200.0,),
                      ],
                    ),
                  ],
                )))),
      ],
    );
  }
 
}

class LadoDireitoCandidato extends StatefulWidget {
  final Function() notifyParent;
  LadoDireitoCandidato({Key? key, required this.notifyParent}) : super(key: key);
  // const LadoDireitoCandidato({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<LadoDireitoCandidato> createState() => _LadoDireitoCandidatoState();
}

class _LadoDireitoCandidatoState extends State<LadoDireitoCandidato> {
  refreshLadoDireitoCandidatoState() {
   setState(() {
    widget.notifyParent();
   });
  }

  @override
  Widget build(BuildContext context) {
    return Column( // Lado Direito Candidato
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Container(
          height: 150,
          width: 400,
          decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: new BorderRadius.circular(1.0),
                color: Colors.white,
              ), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('asset/img/brasao.png'),
              Column(
                children: [
                  Divider(height:50 ),
                  // Text(algarismo_um.toString() + algarismo_dois.toString() ),
                  Text('JUSTIÇA ',  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold ),),
                  Text('TAMANDARÉ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold ),),
                ],
              ),
            ],
          ),),),
        Center(child: Container(
              height: 450,
              // width: double.infinity,            
              width: 400,            
              decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: new BorderRadius.circular(1.0),
                    color: Colors.grey.shade800,
                    // color: Color.fromRGBO(217, 217, 200, 100)
                  ), 
              child: Column(
                children: [
                  Row(  children: [ Container(
                                   height: 50,
                                   color: Colors.white,
                                  //  foregroundDecoration: BoxDecoration(color: Colors.white),
                                  //  decoration: BoxDecoration(color: Colors.white),
                                   child: Divider(height: 200, color: Colors.white)) ] ),
                  Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaUm(),  ],         ),
                  Row(  children: [ LinhaDois(notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaTres(),  ],         ),
                ],
              ))),
      ],
    );
  }
}



class LinhaUm extends StatefulWidget {
  final Function() notifyParent;
  LinhaUm({Key? key, required this.notifyParent}) : super(key: key);
  // const LinhaUm({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<LinhaUm> createState() => _LinhaUmState();
}

class _LinhaUmState extends State<LinhaUm> {

  _onPressedBotao(int digito) {
    setState(() {
      print('onPressdBotao: ' + digito.toString());
      if (algarismo_um_pressionado){
        algarismo_dois = digito ;
      }else{
        algarismo_um = digito ;
        algarismo_um_pressionado = true;
      }
      widget.notifyParent();
     });
  }

  // void _onPressedCorrige() {
  //   print('onPressedCorrige');
  //   algarismo_um = 0;
  //   algarismo_dois = 0;    
  //   algarismo_um_pressionado = false;
  //   widget.notifyParent();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(5),
      padding: const EdgeInsets.fromLTRB(80 ,0 ,80 ,0  ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){_onPressedBotao(1);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          VerticalDivider( width: 16, ),
          IconButton(onPressed: (){_onPressedBotao(2);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          VerticalDivider( width: 16, ),
          // Divider( height: 100, ),
          IconButton(onPressed: (){_onPressedBotao(3);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
        ],
      ),
    );
  }


  // void onPressedBotao() {    
    
    // algarismo_um = 0 ;

  // }
}

class LinhaDois extends StatefulWidget {
  final Function() notifyParent;
  LinhaDois({Key? key, required this.notifyParent}) : super(key: key);  
  // const LinhaDois({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<LinhaDois> createState() => _LinhaDoisState();
}

class _LinhaDoisState extends State<LinhaDois> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(5),
      padding: const EdgeInsets.fromLTRB(20 ,5 ,20 ,5  ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset('asset/img/btn_branco.png'),
          VerticalDivider( width: 60, ),
          IconButton(onPressed: _onPressedCancela, iconSize: 60, icon: Image.asset('asset/img/btn_branco.png')),
          VerticalDivider( width: 16, ),
          // Image.asset('asset/img/btn_corrige.png'),
          IconButton(onPressed: _onPressedCorrige, iconSize: 60, icon: Image.asset('asset/img/btn_corrige.png')),
          VerticalDivider( width: 16, ),
          // Divider( height: 100, ),
          IconButton(onPressed: _onPressedConfirma, iconSize: 60, icon: Image.asset('asset/img/btn_confirma.png')),
          // Image.asset('asset/img/btn_confirma.png'),
        ],
      ),
    );    
  }

  void _onPressedCancela() {
    print('onPressedCancela');
    algarismo_um = 0;
    algarismo_dois = 0;    
    algarismo_um_pressionado = false;
    widget.notifyParent();    
  }

  void _onPressedCorrige() {
    print('onPressedCorrige');
    algarismo_um = 0;
    algarismo_dois = 0;    
    algarismo_um_pressionado = false;
    widget.notifyParent();
  }

  void _onPressedConfirma() async {
    print('onPressedConfirma');
    int new_counter;
    // onPressedConfirma();
    final prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt(algarismo_um.toString() + algarismo_dois.toString());
    if (counter == null) {
      new_counter = 1;
      await prefs.setInt(algarismo_um.toString() + algarismo_dois.toString(), new_counter);
    }else{
      print('counter: ' + counter.toString());
      new_counter = counter!.toInt() + 1;
      await prefs.setInt(algarismo_um.toString() + algarismo_dois.toString(), new_counter);
    }

    // if (counter){
    //     await prefs.setInt(algarismo_um.toString() + algarismo_dois.toString(), counter++);
    // }


    //imprime todos os dados
    final keys = prefs.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
       prefsMap[key] = prefs.get(key);
    }
    print(prefsMap);

    vaiParaTelaInicial();
  }

  void vaiParaTelaInicial() {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyApp() ),
  );
  } 
}

class LinhaTres extends StatelessWidget {
  const LinhaTres({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Direita linha 3');
  }
}