import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/baggage_model.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/logtable_repository.dart';

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
            
      //////////////////log table /////////////////////////
      final log = LogTable(
        page_name: "baggage_repository",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  Future<void> updateBaggageRecord(BaggageModel baggage) async{
    await _db.collection("Baggage").doc(baggage.id).update(baggage.toJson());
    print("Successfully updated");
  }

}