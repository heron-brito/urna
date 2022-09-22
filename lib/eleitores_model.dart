class EleitorModel{
  final int? id;
  final String? nome;
  final String email;

  EleitorModel({this.id,this.nome ,required this.email});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "nome" : nome,
      "email" : email,
    };
  }
}