// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urna/main.dart';
// import 'package:audioplayers_windows/'
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';
// import 'package:just_audio/just_audio.dart';
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
      } else if ( algarismo_um == 9 && algarismo_dois == 5){
        candidato = 'A redemecratização das urnas eletrônicas';
        foto_cadidato ='asset/img/democracia.png';
      } else if ( algarismo_um == 3 && algarismo_dois == 1){
        candidato = 'A importância dos alimentos saudáveis na educação';
        foto_cadidato ='asset/img/ciência.jpg';        
      } else if ( algarismo_um == 7 && algarismo_dois == 6){
        candidato = 'Tecnologia na agricultura';
        foto_cadidato ='asset/img/agricultura.jfif'; 
      } else if ( algarismo_um == 2 && algarismo_dois == 5){
        candidato = 'Como o investimento na ciência impulsiona na democracia';
        foto_cadidato ='asset/img/alimentos saudaveis.jfif'; 
      } else if ( algarismo_um == 1 && algarismo_dois == 8){
        candidato = 'A democracia e o desenvolvimento sustentável da população';
        foto_cadidato ='asset/img/sustentabilidade.jfif';
      } else if ( algarismo_um == 1 && algarismo_dois == 7){
        candidato = 'A democratização da vacina e o projeto SUS';
        foto_cadidato ='asset/img/vacina.jpg';
      } else if ( algarismo_um == 1 && algarismo_dois == 3){
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


  // late AudioPlayer player;
  // @override
  // void initState() {
  //   super.initState();
  //   player = AudioPlayer();
  // }
  // @override
  // void dispose() {
  //   player.dispose();
  //   super.dispose();
  // }


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
              borderRadius: BorderRadius.circular(16.0),
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

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column( //Lado Esquero Número selecionado
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Container(
                height: 500,
                // width: double.infinity,            
                // width: 700,            
                decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey,
                    ), 
                child: Container(
                  height: 300,
                //   width: 400,            
                  decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.0),
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(height: 100, thickness: 0.1),
                            Text('GRUPO:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                            Divider(height: 100, thickness: 0.1),
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
                                VerticalDivider(width: 10, thickness: 0.1),
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
                                VerticalDivider(width: 200, thickness: 0.1)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Divider(height: 100, thickness: 0.1),
                            // Text('Tirica      ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                            FittedBox(
                                // fit: BoxFit.fitWidth,
                                fit: BoxFit.fitWidth,
                                child: 
                                   ConstrainedBox(
                                     constraints: BoxConstraints(minWidth: 1, minHeight: 1), // here
                                     child: Text( candidato ,  style: TextStyle(
                                          // fontSize: 25.0, 
                                          fontWeight: FontWeight.bold
                                          ),),
                                   ),
                                 ),
                                //    Text( candidato + '      ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                            Divider(height: 50, thickness: 0.1),
                            Image.asset(foto_cadidato, height: 200.0,),
                            // Image.asset('asset/img/tiririca.webp', height: 200.0,),
                          ],
                        ),
                      ),
                    ],
                  )))),
        ],
      ),
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
        // Tablet ou Celular -> ate container
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
                  Divider(height:50 , thickness: 0.1),
                  // Text(algarismo_um.toString() + algarismo_dois.toString() ),
                  Text('JUSTIÇA ',  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold ),),
                  Text('TAMANDARÉ', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold ),),
                ],
              ),
            ],
          ),
          ),),
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
                                   child: Divider(height: 200, thickness: 0.1, color: Colors.white)) ] ),
                  Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaDois( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaTres( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  Row(  children: [ LinhaQuatro( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaUm( notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
                  // Row(  children: [ LinhaUm(),  ],         ),
                  Row(  children: [ LinhaDeBaixo(notifyParent: refreshLadoDireitoCandidatoState ),  ],         ),
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

  @override
  State<LinhaUm> createState() => _LinhaUmState();
}

class _LinhaUmState extends State<LinhaUm> {

  // late AudioPlayer player;
  // @override
  // void initState() {
  //   super.initState();
  //   player = AudioPlayer();
  // }
  // @override
  // void dispose() {
  //   player.dispose();
  //   super.dispose();
  // }


  void _tocaSomBotao() async {
    // final player = AudioPlayer();
    // await player.play(AssetSource('sounds/fim.wav'));    

    // player.play(UrlSource('asset/img/fim.m4a'));
    // await player.play(AssetSource('asset/img/fim.m4a'));    
    // await player.play(AssetSource('img/fim.m4a'));    

    // await player.setAsset('assets/soungs/fim.wav');
    // player.play();
  }

  _onPressedBotao(int digito) {
    _tocaSomBotao();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(80 ,0 ,80 ,0  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(1);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(1);}, child: Text('1', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, thickness: 0.1 ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(2);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(2);}, child: Text('2', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, thickness: 0.1 ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(3);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(3);}, child: Text('3', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
        ],
      ),
    );
  }

}



class LinhaDois extends StatefulWidget {
  final Function() notifyParent;
  LinhaDois({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<LinhaDois> createState() => _LinhaDoisState();
}

class _LinhaDoisState extends State<LinhaDois> {

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(80 ,0 ,80 ,0  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(onPressed: (){_onPressedBotao(4);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          // VerticalDivider( width: 16, ),
          // IconButton(onPressed: (){_onPressedBotao(5);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          // VerticalDivider( width: 16, ),
          // IconButton(onPressed: (){_onPressedBotao(6);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(4);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(4);}, child: Text('4', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(5);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(5);}, child: Text('5', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(6);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(6);}, child: Text('6', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),           
        ],
      ),
    );
  }

}


class LinhaTres extends StatefulWidget {
  final Function() notifyParent;
  LinhaTres({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<LinhaTres> createState() => _LinhaTresState();
}

class _LinhaTresState extends State<LinhaTres> {

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(80 ,0 ,80 ,0  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(onPressed: (){_onPressedBotao(7);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          // VerticalDivider( width: 16, ),
          // IconButton(onPressed: (){_onPressedBotao(8);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          // VerticalDivider( width: 16, ),
          // IconButton(onPressed: (){_onPressedBotao(9);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(7);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(7);}, child: Text('7', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(8);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(8);}, child: Text('8', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),          
          VerticalDivider( width: 16, ),
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(9);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(9);}, child: Text('9', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),           
        ],
      ),
    );
  }

}




class LinhaQuatro extends StatefulWidget {
  final Function() notifyParent;
  LinhaQuatro({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<LinhaQuatro> createState() => _LinhaQuatroState();
}

class _LinhaQuatroState extends State<LinhaQuatro> {

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


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(80 ,0 ,80 ,0  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(onPressed: (){_onPressedBotao3(7);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          // Divider(height: 150,),
          VerticalDivider( width: 80, ),
          // IconButton(onPressed: (){_onPressedBotao(0);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
          Stack(  alignment: AlignmentDirectional.center , children: [ 
                IconButton(onPressed: (){_onPressedBotao(0);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),
                GestureDetector( onTap: (){_onPressedBotao(0);}, child: Text('0', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 197, 197, 197)))),   ] ),           
          VerticalDivider( width: 16, ),
          Divider(height: 50,),
          // IconButton(onPressed: (){_onPressedBotao3(9);}, iconSize: 50, icon: Image.asset('asset/img/urna_notao_01.png')),          
        ],
      ),
    );
  }

}



class LinhaDeBaixo extends StatefulWidget {
  final Function() notifyParent;
  LinhaDeBaixo({Key? key, required this.notifyParent}) : super(key: key);  

  @override
  State<LinhaDeBaixo> createState() => _LinhaDeBaixo();
}

class _LinhaDeBaixo extends State<LinhaDeBaixo> {
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
          VerticalDivider( width: 110, ),
          // IconButton(onPressed: _onPressedCancela, iconSize: 60, icon: Image.asset('asset/img/btn_branco.png')),
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

  void _tocaSom() async {
    // final player = AudioPlayer();
    // player.play(UrlSource('asset/img/fim.m4a'));
    // await player.play(AssetSource('sounds/note1.wave'));    
  }

  void _onPressedConfirma() async {
    print('onPressedConfirma');
    int new_counter;
    String grupo_string;
    int grupo;
    grupo_string =  '${algarismo_um.toString()}${algarismo_dois.toString()}' ;
    print(grupo_string);
    grupo = int.parse(grupo_string);
    print(grupo);

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


    //imprime todos os dados
    final keys = prefs.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
       prefsMap[key] = prefs.get(key);
    }
    print(prefsMap);

    if ( grupo == 17 || grupo == 18 || grupo == 25 || grupo == 31 || grupo == 76 || grupo == 95) {
      _onPressedCorrige();
      // _tocaSom();
      // sleep(Duration(seconds: 2) );
      vaiParaTelaInicial();
    } else {
       final snackBar = SnackBar(
               content: const Text('Candidato inválido  !!!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  void vaiParaTelaInicial() {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MyApp() ),
  );
  } 
}
