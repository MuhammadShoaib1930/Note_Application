
import 'dart:convert';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted
  }){
    return TodoModel(
      id: id??this.id, 
      title: title??this.title, 
      description: description??this.description, 
      isCompleted: isCompleted??this.isCompleted
      );
  }
  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'id':id,
      'title':title,
      'description':description,
      'isCompleted':isCompleted
    };
  }
  factory TodoModel.formMap(Map<String,dynamic> map){
    return TodoModel(
      id: map['id'] as String, 
      title: map['title'] as String, 
      description: map['description'] as String, 
      isCompleted: map['isCompleted'] as bool
      );
  }
  String toJson()=> json.encode(toMap());
  factory TodoModel.fromJson(String source)=> TodoModel.formMap(json.decode(source) as Map<String , dynamic>);
  @override
  String toString(){
    return 'TodoModel(id: $id, title: $title, description: $description,isCompleted; $isCompleted)';
  }
  @override
  bool operator ==(covariant TodoModel other){
    if(identical(this, other)) return true;
    return 
      other.id == id && 
      other.title == title &&
      other.description == description &&
      other.isCompleted == isCompleted; 
  }
  @override
  int get hashCode{
    return id.hashCode ^
    title.hashCode ^
    description.hashCode ^
    isCompleted.hashCode ;
  }
}