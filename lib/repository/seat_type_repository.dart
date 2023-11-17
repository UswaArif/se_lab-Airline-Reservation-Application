import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/seat_type_model.dart';

class SeatTypeRepository{
  static SeatTypeRepository? _instance;
  SeatTypeRepository._();

  factory SeatTypeRepository() {
    _instance ??= SeatTypeRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  final _db = FirebaseFirestore.instance;

  Future<List<SeatTypeModel>> allSeatsType()async{
    final snapshot = await _db.collection("SeatType").get();
    final userData = snapshot.docs.map((e) => SeatTypeModel.fromSnapshot(e)).toList();
    return userData;
  }
}