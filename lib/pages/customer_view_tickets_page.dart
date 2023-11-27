import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/classes/payment_model.dart';
import 'package:se_lab/classes/seats_model.dart';
import 'package:se_lab/classes/ticket_model.dart';
import 'package:se_lab/repository/logtable_repository.dart';
import 'package:se_lab/repository/payment_repository.dart';
import 'package:se_lab/repository/seat_repository.dart';
import 'package:se_lab/repository/ticket_repository.dart';

class CustomerAllTicket extends StatefulWidget {
  final Map<String, dynamic> user;
  const CustomerAllTicket({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<CustomerAllTicket> createState() => _CustomerAllTicketState();
}

class _CustomerAllTicketState extends State<CustomerAllTicket> {
  List<Map<String, dynamic>> ticketList = [];
  List<Map<String, dynamic>> matchedticketList = [];
  List<Map<String, dynamic>> SeatDataList = [];
  //List<Map<String, dynamic>> paymentDataList = [];
  @override
  void initState() {
    super.initState();
    getmatchedTicket();
    getSeatData();
    //getPaymentData();
  }
  Future<void> getmatchedTicket() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Ticket")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve and store flight data in the list
        ticketList = querySnapshot.docs.map((ticketSnapshot) {
        final data = ticketSnapshot.data() as Map<String, dynamic>;
        final documentId = ticketSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();  

      for (Map<String, dynamic> ticket in ticketList) {                         
        if (ticket['UserId'] == widget.user['documentID'] && ticket['Active'] == true) {
          matchedticketList.add(ticket);                     
        }                        
      }   
        setState(() {});
      } else {
        print("No Ticket data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");

      //log table
      final log = LogTable(
        page_name: "customer_view_tickets_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  Future<void> getSeatData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Seats")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve seat data in the list
        SeatDataList = querySnapshot.docs.map((seatSnapshot) {
        final data = seatSnapshot.data() as Map<String, dynamic>;
        final documentId = seatSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();
  
        setState(() {});
      } else {
        print("No Seat data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      
      //log table
      final log = LogTable(
        page_name: "customer_view_tickets_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  /*Future<void> getPaymentData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Payment")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve seat data in the list
        paymentDataList = querySnapshot.docs.map((PaymentSnapshot) {
        final data = PaymentSnapshot.data() as Map<String, dynamic>;
        final documentId = PaymentSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();
  
        setState(() {});
      } else {
        print("No Payment data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      
      //log table
      final log = LogTable(
        page_name: "customer_view_tickets_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tickets"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          Container(
            /*decoration: BoxDecoration(
              color: Colors.deepPurpleAccent, // Background color
              border: Border.all(color: Colors.deepPurple, width: 2.0), // Add a border
            ),*/
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: matchedticketList.length,
                itemBuilder: (context, index) {
                  final ticketData = matchedticketList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:Colors.deepPurpleAccent,
                        border: Border.all(color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text("Passport NO.",                            
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text("${ticketData['PassportNumber']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // You can apply any styling you want
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Name: ${ticketData['Name']}",
                                style: const TextStyle(                                 
                                ),
                              ),                             
                              Text("CNIC: ${ticketData['CNIC']}",
                                style: const TextStyle(                                 
                                ),
                              ),
                              Text("Email: ${ticketData['Email']}",
                                style: const TextStyle(                                 
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Text("Price: ${ticketData['Price']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Ticket Cancellation: ",
                              style: TextStyle(
                                color: Colors.red 
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.airplane_ticket_rounded,color: Colors.red,), 
                            onPressed: () {
                            
                              Map<String, dynamic> seatobj = {};
                              ticketData['Active'] = false;
                              final ticket = TicketModel(
                                id: ticketData['documentId'],
                                ticket_buyer_name: ticketData['Name'],
                                passport_number: ticketData['PassportNumber'],
                                cnic: ticketData['CNIC'],
                                email: ticketData['Email'],
                                price: ticketData['Price'],
                                user_id: ticketData['UserId'],
                                flight_id: ticketData['FlightId'],
                                seat_id: ticketData['SeatId'],
                                created_at: ticketData['CreatedAt'],
                                updated_at: Timestamp.now(),
                                active: false,
                              );
                              final ticketRepository = TicketRepository();
                              ticketRepository.updateTicketRecord(ticket);

                              for (Map<String, dynamic> seat in SeatDataList) {                         
                                if (seat['documentId'] == ticketData['SeatId']) {
                                  seatobj = seat;
                                  //break;
                                }                        
                              }   
                              //print(seatobj);
                              seatobj['SeatStatus'] = "available";  
                              final SeatModel updatedSeat = SeatModel(
                                id: seatobj['documentId'],
                                seat_number: seatobj['SeatNumber'],
                                seat_type_id: seatobj['SeatTypeId'],
                                seat_status: 'available',
                                seat_attribute: seatobj['SeatAttribute'],
                                discount: seatobj['Discount'],
                                flight_id: seatobj['FlightId'],
                                created_at: seatobj['CreatedAt'],
                                updated_at: Timestamp.now(),
                                active: seatobj['Active']
                              );
                              final seatRepository = SeatRepository();
                              seatRepository.updateSeatRecord(updatedSeat);

                              
                              print("ticket canceled");
                            },
                            
                          ),
                        ],
                      ),
                    ),                         
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}