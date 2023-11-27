import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/log_table.dart';

class LogTableRepository{
  static LogTableRepository? _instance;
  LogTableRepository._();

  // Factory constructor to create or retrieve the instance
  factory LogTableRepository() {
    _instance ??= LogTableRepository._(); 
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  
  void createLog(BuildContext context, LogTable seat) async {
    try {
      await _db.collection("LogTable").add(seat.toJson());
    } catch (e) {
      print(e);
    }
  }
}