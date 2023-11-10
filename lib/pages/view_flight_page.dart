import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se_lab/classes/flight_model.dart';
import 'package:se_lab/classes/user_model.dart';
import 'package:se_lab/pages/add_flight_page.dart';
import 'package:se_lab/pages/update_flight_page.dart';


class ViewFlight extends StatefulWidget {
  const ViewFlight({super.key});

  @override
  State<ViewFlight> createState() => _viewFlightState();
}

class _viewFlightState extends State<ViewFlight> {
  List<Map<String, dynamic>> flightDataList = [];
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    // Call the function to get flight data from Firebase when the widget is initialized
    getFlightData();
  }

String _formatTimestamp(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  //final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  final DateFormat format = DateFormat('MMMM d, HH:mm');
  final String formattedDateTime = format.format(dateTime);
  return formattedDateTime;
}

  Future<void> getFlightData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Flight")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve and store flight data in the list
        /*flightDataList = querySnapshot.docs
            .map((flightSnapshot) => flightSnapshot.data() as Map<String, dynamic>)
            .toList();*/
        flightDataList = querySnapshot.docs.map((flightSnapshot) {
        final data = flightSnapshot.data() as Map<String, dynamic>;
        final documentId = flightSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();
        //print(flightDataList);
        // Force a rebuild to display the flight data
        setState(() {});
      } else {
        print("No flight data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }

  /*Future<void> getFlightData()async{
    try{
      // Query Firestore to find a document with the matching email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Flight").get();

      // Check if there is a matching document
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming there's only one match)
        DocumentSnapshot userDataSnapshot = querySnapshot.docs.first;

        // Access user data from Firestore
        Map<String, dynamic> flightData = userDataSnapshot.data() as Map<String, dynamic>;
        print(flightData);
      } 
      else {
        // No matching document found in Firestore
        print("Flight data not found in Firestore.");
      }
    }
    catch (e) {
      print("An unexpected error occurred: $e");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft, // Align "View Flight" text to the left
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0), // Margin from the left side
                  child: Text(
                    "View Flight",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0), // Margin from the right side
                  child: Column(
                    children: [
                      const Text(
                        "Add Flight",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Material(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddFlight()), 
                            );

                          },
                          child: Container(
                            width: 40, 
                            height: 40, 
                            child: const Center(
                              child: Text(
                                "+",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          // Curved top shape SizedBox
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            
              
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent, // Background color
                  border: Border.all(color: Colors.deepPurple, width: 2.0), // Add a border
                ),
                child: SizedBox(
                  height: 400, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: flightDataList.length,
                    itemBuilder: (context, index) {
                      final flightData = flightDataList[index];
                      //print(flightData);
                      return GestureDetector(
                        onTap: () {
                          print('Container tapped');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateFlightPage(
                                flightData: flightData,                             
                              ),
                            ),
                          );
                          print(flightData);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: isTapped ? Colors.white: Colors.white,
                            
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Text("FLIGHT NO.",
                                  
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text("${flightData['FlightNumber']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, // You can apply any styling you want
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${flightData['Source']}",
                                    style: const TextStyle(
                                      fontSize: 25, 
                                    ),
                                  ),
                                  const Icon(
                                    Icons.flight_takeoff_outlined, 
                                    size: 25, 
                                    color: Colors.red,
                                  ),
                                  Text("${flightData['Destination']}",
                                    style: const TextStyle(
                                      fontSize: 25, 
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Departure Time",
                                    style: TextStyle(
                                      fontSize: 10, 
                                    ),
                                  ),
                                  Text("Arrival Time        ",
                                    style: TextStyle(
                                      fontSize: 10, 
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatTimestamp(flightData['DepartureTime']),
                                    style: const TextStyle(
                                      fontSize: 10, 
                                    ),
                                  ),
                                  Text(_formatTimestamp(flightData['ArrivalTIme']),
                                    style: const TextStyle(
                                      fontSize: 10, 
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Divider( 
                                color: Colors.black, 
                                thickness: 1, 
                              ), 
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Flight Price: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${flightData['Price']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                              // Add more flight data fields here
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
               
          ),
        ],
      ),
    );
  }
} 