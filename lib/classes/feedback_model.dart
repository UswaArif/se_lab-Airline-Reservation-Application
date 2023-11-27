import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel{
  final String? id;
  final String feedback_text;
  final String user_id;
  final Timestamp created_at;

  const FeedbackModel({
    this.id, 
    required this.feedback_text,
    required this.user_id,
    required this.created_at,
  });
  
 //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "Text" : feedback_text,
      "UserId" : user_id,
      "CreatedAt" : created_at,
    };
  }
  
  factory FeedbackModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return FeedbackModel(
      id: document.id, 
      feedback_text: data["Text"], 
      user_id: data["UserId"], 
      created_at: data["CreatedAt"],
      );
  }
}