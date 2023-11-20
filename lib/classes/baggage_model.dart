import 'package:cloud_firestore/cloud_firestore.dart';

class BaggageModel{
  final String? id;
  final String seat_type_class;
  final int weight_per_kg;
  final int bag_counts;
  final String size_restriction;
  final int excess_baggage_fee_per_kg;
  final Timestamp created_at;
  final Timestamp updated_at;
  final bool active;

  const BaggageModel({
    this.id, 
    required this.seat_type_class,
    required this.weight_per_kg,
    required this.bag_counts,
    required this.size_restriction,
    required this.excess_baggage_fee_per_kg,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });
  
 //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "SeatTypeClass" : seat_type_class,
      "WeightperKg" : weight_per_kg,
      "BagCounts" : bag_counts,
      "SizeRestriction": size_restriction,
      "ExcessBaggageFeePerKg": excess_baggage_fee_per_kg,
      "CreatedAt" : created_at,
      "UpdatedAt" : updated_at,
      "Active" : active,
    };
  }
  
  //Map baggage fetched data from Firebase to BaggageModel
  factory BaggageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return BaggageModel(
      id: document.id, 
      seat_type_class: data["SeatTypeClass"], 
      weight_per_kg: data["WeightperKg"], 
      bag_counts: data["BagCounts"], 
      size_restriction: data["SizeRestriction"], 
      excess_baggage_fee_per_kg: data["ExcessBaggageFeePerKg"],
      created_at: data["CreatedAt"],
      updated_at: data["UpdatedAt"],
      active: data["Active"]
      );
  }
}