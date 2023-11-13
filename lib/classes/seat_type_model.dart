import 'package:cloud_firestore/cloud_firestore.dart';

class SeatTypeModel{
  final String? id;
  final String name;
  final int price;
  final String description;
  final Timestamp created_at;
  final bool active;

  const SeatTypeModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.created_at,
    required this.active,
  });

  //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "Name" : name,
      "Price" : price,
      "Description" : description,
      "CreatedAt" : created_at,
      "Active": active,
    };
  }

  //Map Seat fetched data from Firebase to SeatTypeModel
  factory SeatTypeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return SeatTypeModel(
      id: document.id, 
      name: data["Name"], 
      price: data["Price"], 
      description: data["Description"], 
      created_at: data["CreatedAt"], 
      active: data["Active"],
      );
  }
}