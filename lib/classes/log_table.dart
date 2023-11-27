import 'package:cloud_firestore/cloud_firestore.dart';

class LogTable{
  final String? id;
  final String page_name;
  final String error;

  const LogTable({
    this.id, 
    required this.page_name,
    required this.error,
  });
  
 //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "PageName" : page_name,
      "Error" : error,
    };
  }
}