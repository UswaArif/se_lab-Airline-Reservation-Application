import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel{
  final String? id;
  final String ticket_buyer_name;
  final int passport_number;
  final int cnic;
  final String email;
  final int price;
  final String user_id;
  final String flight_id;
  final String seat_id;
  final Timestamp created_at;
  final Timestamp updated_at;
  final bool active;

  const TicketModel({
    this.id,
    required this.ticket_buyer_name,
    required this.passport_number,
    required this.cnic,
    required this.email,
    required this.price,
    required this.user_id,
    required this.flight_id,
    required this.seat_id,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });

  //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "Name" : ticket_buyer_name,
      "PassportNumber" : passport_number,
      "CNIC" : cnic,
      "Email" : email,
      "Price" : price,
      "UserId" : user_id,
      "FlightId" : flight_id,
      "SeatId" : seat_id,
      "CreatedAt" : created_at,
      "UpdatedAt" : updated_at,
      "Active": active,
    };
  }

  //Map Ticket fetched data from Firebase to TicketModel
  factory TicketModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return TicketModel(
      id: document.id, 
      ticket_buyer_name: data["Name"], 
      passport_number: data["PassportNumber"], 
      cnic: data["CNIC"], 
      email: data["Email"],
      price: data["Price"],  
      user_id: data["UserId"],  
      flight_id: data["FlightId"],  
      seat_id: data["SeatId"], 
      created_at: data["CreatedAt"], 
      updated_at: data["UpdatedAt"], 
      active: data["Active"],
      );
  }
}