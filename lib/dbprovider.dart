import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import './eleitores_model.dart'; //import model class
import 'dart:io';
import 'dart:async';



class EleitoresDbProvider{
    
   Future<Database> init() async {
       Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
       final path = join(directory.path,"eleitores.db"); //create path to database
   
         return await openDatabase( //open the database or create a database if there isn't any
           path,
           version: 1,
           onCreate: (Database db,int version) async{
             await db.execute("""
             CREATE TABLE Eleitores(
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             nome TEXT,
             email TEXT)"""
         );
       });
     }


     Future<int> addItem(EleitorModel item) async{ //returns number of items inserted as an integer
    
        final db = await init(); //open database
    
        return db.insert("Eleitores", item.toMap(), //toMap() function from MemoModel
        // conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
        );
     }


  //   Future<List<EleitorModel>> fetchEleitores() async{ //returns the memos as a list (array)
    
  //     final db = await init();
  //     final maps = await db.query("Eleitores"); //query all the rows in a table as an array of maps
  
  //     return List.generate(maps.length, (i) { //create a list of memos
  //       return EleitorModel(              
  //         id: maps[i]['id'],
  //         nome: maps[i]['nome'],
  //         email: maps[i]['email'],
  //       );
  //   });
  // } 


  Future<int> deleteEleitor(int id) async{ //returns number of items deleted
    final db = await init();
  
    int result = await db.delete(
      "Eleitores", //table name
      where: "id = ?",
      whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }


  Future<int> updateMemo(int id, EleitorModel item) async{ // returns the number of rows updated
  
    final db = await init();
  
    int result = await db.update(
      "Eleitores", 
      item.toMap(),
      where: "id = ?",
      whereArgs: [id]
      );
      return result;
 }
       
}