import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/baggage_model.dart';

class BaggageRepository{
  static BaggageRepository? _instance;
  BaggageRepository._();

  // Factory constructor to create or retrieve the instance
  factory BaggageRepository() {
    _instance ??= BaggageRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  void createBaggage(BuildContext context, BaggageModel baggage) async {
    try {
      await _db.collection("Baggage").add(baggage.toJson());
      final snackBar =  SnackBar(
        content: Text("Baggage has been added."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error adding Baggage: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}