import 'package:flutter/material.dart';

class CustomerCheckout extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> flight;
  final Map<String, dynamic> seat;
  const CustomerCheckout({
    Key? key,
    required this.user, required this.flight, required this.seat
  }) : super(key: key);


  @override
  State<CustomerCheckout> createState() => _CustomerCheckoutState();
}

class _CustomerCheckoutState extends State<CustomerCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}