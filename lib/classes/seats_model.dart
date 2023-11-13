import 'package:cloud_firestore/cloud_firestore.dart';

class SeatModel{
  final String? id;
  final int seat_number;
  final String seat_type_id;
  final String seat_status;
  final String seat_attribute;
  final int discount;
  final String flight_id;
  final Timestamp created_at;
  final Timestamp updated_at;
  final bool active;

  const SeatModel({
    this.id,
    required this.seat_number,
    required this.seat_type_id,
    required this.seat_status,
    required this.seat_attribute,
    required this.discount,
    required this.flight_id,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });

  //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "SeatNumber" : seat_number,
      "SeatTypeId" : seat_type_id,
      "SeatStatus" : seat_status,
      "SeatAttribute" : seat_attribute,
      "Discount" : discount,
      "FlightId" : flight_id,
      "CreatedAt" : created_at,
      "UpdatedAt" : updated_at,
      "Active": active,
    };
  }

  //Map Seat fetched data from Firebase to SeatModel
  factory SeatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return SeatModel(
      id: document.id, 
      seat_number: data["SeatNumber"], 
      seat_type_id: data["SeatTypeId"], 
      seat_status: data["SeatStatus"], 
      seat_attribute: data["SeatAttribute"],
      discount: data["Discount"],  
      flight_id: data["FlightId"], 
      created_at: data["CreatedAt"], 
      updated_at: data["UpdatedAt"], 
      active: data["Active"],
      );
  }
}