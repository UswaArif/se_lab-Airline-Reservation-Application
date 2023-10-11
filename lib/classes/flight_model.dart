import 'package:cloud_firestore/cloud_firestore.dart';

class FlightModel{
  final String? id;
  final int flight_number;
  final String source_place;
  final String destination_place;
  final DateTime departure;
  final DateTime arrival;
  final int price;
  final int available_seats;
  final String flight_status;
  final DateTime created_at;
  final DateTime updated_at;
  final bool active;

  const FlightModel({
    this.id, 
    required this.flight_number,
    required this.source_place,
    required this.destination_place,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.available_seats,
    required this.flight_status,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });
  

  toJson(){
    return{
      "FlightNumber" : flight_number,
      "Source" : source_place,
      "Destination" : destination_place,
      "DepartureTime": departure,
      "ArrivalTIme": arrival,
      "Price" : price,
      "AvailableSeats" : available_seats,
      "FlightStatus" : flight_status,
      "CreatedAt" : created_at,
      "UpdatedAt" : updated_at,
      "Active" : active,
    };
  }
  /*
  //Map user fetched data from Firebase to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id: document.id, 
      fullName: data["FullName"], 
      phone: data["Phone"], 
      address: data["Address"], 
      email: data["Email"], 
      password: data["Password"], 
      role: data["Role"], 
      created_at: data["Created_At"], 
      updated_at: data["Updated At"], 
      active: data["Active"],
      );
  }*/
}