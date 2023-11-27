import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/classes/payment_model.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class PaymentRepository{
  static PaymentRepository? _instance;
  PaymentRepository._();

  // Factory constructor to create or retrieve the instance
  factory PaymentRepository() {
    _instance ??= PaymentRepository._(); 
    return _instance!;
  }

  // Your other class methods and properties here
  final _db = FirebaseFirestore.instance;
  
  void createPayment(BuildContext context, PaymentModel payment) async {
    try {
      await _db.collection("Payment").add(payment.toJson());
      final snackBar =  SnackBar(
        content: Text("Payment has been added."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error adding Payment: $e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //////////////////log table /////////////////////////
      final log = LogTable(
        page_name: "payment_repository",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  Future<void> updatePaymentRecord(PaymentModel payment) async{
    await _db.collection("Payment").doc(payment.id).update(payment.toJson());
    print("Successfully updated payment");
  }
}