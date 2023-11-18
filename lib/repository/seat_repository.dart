import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/seats_model.dart';

class SeatRepository{
  static SeatRepository? _instance;
  SeatRepository._();

  // Factory constructor to create or retrieve the instance
  factory SeatRepository() {
    _instance ??= SeatRepository._(); 
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  
  void createSeat(BuildContext context, SeatModel seat) async {
    try {
      await _db.collection("Seats").add(seat.toJson());
      final snackBar =  SnackBar(
        content: Text("Seat has been added."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error adding Seat: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> updateSeatRecord(SeatModel seat) async{
    await _db.collection("Seats").doc(seat.id).update(seat.toJson());
    print("Successfully updated seats");
  }
}