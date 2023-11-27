import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel{
  final String? id;
  final String user_id;
  final String payment_method_id;
  final int paid_amount;
  final String ticket_id;
  final String bank_name;
  final int account_no;
  final String payment_status;
  final Timestamp created_at;
  final Timestamp updated_at;
  final bool active;

  const PaymentModel({
    this.id,
    required this.user_id,
    required this.payment_method_id,
    required this.paid_amount,
    required this.ticket_id,
    required this.bank_name,
    required this.account_no,
    required this.payment_status,
    required this.created_at,
    required this.updated_at,
    required this.active,
  });

  //added Map<String, dynamic>
  Map<String, dynamic> toJson(){
    return{
      "UserId" : user_id,
      "PaymentMethodId" : payment_method_id,
      "PaidAmount" : paid_amount,
      "TicketId" : ticket_id,
      "BankName" : bank_name,
      "AccountNo" : account_no,
      "PaymentStatus" : payment_status,
      "CreatedAt" : created_at,
      "UpdatedAt" : updated_at,
      "Active": active,
    };
  }

  //Map Payment Method fetched data from Firebase to PaymentModel
  factory PaymentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return PaymentModel(
      id: document.id, 
      user_id: data["UserId"], 
      payment_method_id: data["PaymentMethodId"],     
      paid_amount: data["PaidAmount"], 
      ticket_id: data["TicketId"],
      bank_name: data["BankName"],  
      account_no: data["AccountNo"], 
      payment_status: data["PaymentStatus"], 
      created_at: data["CreatedAt"], 
      updated_at: data["UpdatedAt"], 
      active: data["Active"],
    );
  }
}