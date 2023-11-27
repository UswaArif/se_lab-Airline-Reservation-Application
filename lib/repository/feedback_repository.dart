import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/feedback_model.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class FeedbackRepository{
  static FeedbackRepository? _instance;
  FeedbackRepository._();

  // Factory constructor to create or retrieve the instance
  factory FeedbackRepository() {
    _instance ??= FeedbackRepository._(); // Create the instance if it doesn't exist
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  void createFeedback(BuildContext context, FeedbackModel feedback) async {
    try {
      await _db.collection("Feedback").add(feedback.toJson());
      final snackBar =  SnackBar(
        content: Text("Feedback is sent."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error sending Feedback: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
            
      //////////////////log table /////////////////////////
      final log = LogTable(
        page_name: "feedback_repository",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }
}