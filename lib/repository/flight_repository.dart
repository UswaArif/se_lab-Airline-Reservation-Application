import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/flight_model.dart';

class FlightRepository{
  //static FlightRepository get instance => Get.find();
  static FlightRepository? _instance;
  //FlightRepository userRepository = FlightRepository(); // Get an instance
  // Private constructor to prevent external instantiation
  FlightRepository._();

  // Factory constructor to create or retrieve the instance
  factory FlightRepository() {
    _instance ??= FlightRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  void createFlight(BuildContext context, FlightModel flight) async {
    try {
      await _db.collection("Flight").add(flight.toJson());
      final snackBar =  SnackBar(
        content: Text("Flight has been added."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error adding Flight: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
