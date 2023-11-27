import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel{
  final String? id;
  final String type;
  final Timestamp created_at;
  final bool active;

  const PaymentMethodModel({
    this.id,
    required this.type,
    required this.created_at,
    required this.active,
  });

  //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "Type" : type,
      "CreatedAt" : created_at,
      "Active": active,
    };
  }

  //Map Payment Method fetched data from Firebase to PaymentMethodModel
  factory PaymentMethodModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return PaymentMethodModel(
      id: document.id, 
      type: data["Type"], 
      created_at: data["CreatedAt"], 
      active: data["Active"],
    );
  }
}