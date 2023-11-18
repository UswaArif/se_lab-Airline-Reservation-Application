import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewSeat extends StatefulWidget {
  const ViewSeat({super.key});

  @override
  State<ViewSeat> createState() => _ViewSeatPageState();
}

class _ViewSeatPageState extends State<ViewSeat> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightnumber = TextEditingController();
  List<Map<String, dynamic>> flightDataList = [];
  List<Map<String, dynamic>> SeatDataList = [];
  bool isMatchFound = false;
  bool showAdditionalWidget = false; 
  List<Map<String, dynamic>> matchedSeatList = [];
  List<bool> seatHoverStates = [];
  @override
  void initState() {
    super.initState();
    // Call the function to get flight data from Firebase when the widget is initialized
    getFlightNumber();
    getSeatData();
  }
  Future<void> getFlightNumber() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Flight")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve and store flight data in the list
        flightDataList = querySnapshot.docs.map((flightSnapshot) {
        final data = flightSnapshot.data() as Map<String, dynamic>;
        final documentId = flightSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();
        //print(flightDataList);      
        setState(() {});
      } else {
        print("No flight data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("View Seats"),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _flightnumber,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Flight Number is empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Flight Number",
                      hintText: "Enter the Flight Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String? flightDocumentId;
                          for (Map<String, dynamic> flightData in flightDataList) {     
                            if (flightData['FlightNumber'] == int.tryParse(_flightnumber.text)) {
                              isMatchFound = true;
                              flightDocumentId = flightData['documentId'];
                              print("Flight Number is matched");
                              break;
                            }
                            else{
                              isMatchFound = false;
                            }
                          }
                          if (isMatchFound) {
                            setState(() {
                              // Resetting the lists and variables
                              matchedSeatList.clear();
                              showAdditionalWidget = true;
                            });
                            for (Map<String, dynamic> seatData in SeatDataList) {
                              if (seatData['FlightId'] == flightDocumentId) {
                                setState(() {
                                  matchedSeatList.add(seatData);
                                });
                              }
                            }
                            /*for (Map<String, dynamic> seatData in SeatDataList)
                            {
                              if (seatData['FlightId'] == flightDocumentId)
                              {
                                matchedSeatList.add(seatData);
                                setState(() {
                                  showAdditionalWidget = true;
                                });
                              }
                            }*/
                            
                          }
                          else{                            
                            print("No match found");
                            setState(() {
                              // Resetting the lists and variables
                              matchedSeatList.clear();
                              showAdditionalWidget = false; // Hiding additional widget if no match found
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('No match found in flight data for seats'),
                                );
                              },
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                  const SizedBox(height: 12),
                      // Conditional widget creation based on showAdditionalWidget flag
                  if (showAdditionalWidget)                   
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
                          itemCount: matchedSeatList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final seat = matchedSeatList[index];
                            if (seatHoverStates.length <= index) {
                              seatHoverStates.add(false);
                            }
                            return GestureDetector(
                              onTap: () {
                                print('Container tapped');
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateFlightPage(
                                      flightData: flightData,                             
                                    ),
                                  ),
                                );*/
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  // Change color when mouse enters the region
                                  setState(() {
                                    seatHoverStates[index] = true;
                                  });
                                },
                                onExit: (_) {
                                  // Change color back when mouse exits the region
                                  setState(() {
                                    seatHoverStates[index] = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(16.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: seatHoverStates[index]
                                    ? Color.fromARGB(255, 219, 209, 221)
                                    : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Text("SEAT NO.",
                                          
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text("${seat['SeatNumber']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold, // You can apply any styling you want
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Feature:",
                                            style: TextStyle(
                                              fontSize: 15, 
                                            ),
                                          ),
                                          Text("Status:",
                                            style: TextStyle(
                                              fontSize: 15, 
                                            ),
                                          ),
                                          Text("Discount:",
                                            style: TextStyle(
                                              fontSize: 15, 
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${seat['SeatAttribute']}",
                                            style: const TextStyle(
                                              fontSize: 15, 
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("${seat['SeatStatus']}",
                                            style: const TextStyle(
                                              fontSize: 15, 
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("${seat['Discount']}",
                                            style: const TextStyle(
                                              fontSize: 15, 
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
