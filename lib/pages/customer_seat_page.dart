import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/pages/customer_checkout_page.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class CustomerSeatPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> flightData;
  const CustomerSeatPage({
    Key? key,
    required this.userData, required this.flightData
  }) : super(key: key);

  @override
  State<CustomerSeatPage> createState() => _CustomerSeatPageState();
}

class _CustomerSeatPageState extends State<CustomerSeatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedSeatType;
  List<Map<String, dynamic>> seatDataList = [];
  List<Map<String, dynamic>> seatTypeDataList = [];
  bool isMatchFound = false;
  List<Map<String, dynamic>> matchedseatList = [];
  bool showAdditionalWidget = false;
  List<bool> seatHoverStates = [];
  Map<String, dynamic> seatTypeObject = {};

  @override
  void initState() {
    super.initState();
    getSeatData();
    getSeatTypeData();
  }

  Future<void> getSeatData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Seats")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve seat data in the list
        seatDataList = querySnapshot.docs.map((seatSnapshot) {
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
        page_name: "customer_seat_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }
  
  Future<void> getSeatTypeData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("SeatType")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        seatTypeDataList = querySnapshot.docs.map((seatSnapshot) {
        final data = seatSnapshot.data() as Map<String, dynamic>;
        final documentId = seatSnapshot.id; 
        data['documentId'] = documentId; 
        return data;
      }).toList();
        //print(flightDataList);
        // Force a rebuild to display the flight data
        setState(() {});
      } else {
        print("No Seat Type data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      //log table
      final log = LogTable(
        page_name: "customer_seat_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Seats"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.airline_seat_recline_normal_outlined, color: Colors.deepPurple),
                      labelText: 'Seat Type',
                      labelStyle: TextStyle(
                        color: Colors.deepPurple,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    value: selectedSeatType,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSeatType = newValue!;
                        //print(selectedSeatType);
                      });
                    },
                    items: <String>['Economy', 'Business Class', 'First Class']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a seat type';
                      }
                      return null;
                    },
                  ),   
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //print(seatDataList);
                        matchedseatList.clear();
                        for (Map<String, dynamic> seatData in seatDataList) {  
                          
                          if (seatData['FlightId'] == widget.flightData['documentId']) {
                            for (Map<String, dynamic> seattypeData in seatTypeDataList)
                            {
                              if(seatData['SeatTypeId'] == seattypeData['documentId'] && seattypeData['Name'] == selectedSeatType)
                              {
                                matchedseatList.add(seatData);  
                                seatTypeObject = seattypeData;
                                isMatchFound = true;
                                print("Seat is matched");   
                                break;                             
                              }                                                    
                            }                             
                          }                         
                        } 
                        //Sorting the list
                        matchedseatList.sort((a, b) => a['SeatNumber'].compareTo(b['SeatNumber']));
                        print(matchedseatList); 
                        if (matchedseatList.isNotEmpty) {
                          setState(() {
                            showAdditionalWidget = true;
                          });
                        }
                        else{                            
                          print("No seat available");
                          setState(() {
                            showAdditionalWidget = false; // Hiding additional widget if no match found
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('No Seat is available'),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 12),
                  if (showAdditionalWidget)  
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
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: matchedseatList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final seatData = matchedseatList[index];
                              if (seatHoverStates.length <= index) {
                                seatHoverStates.add(false);
                              }
                              return GestureDetector(
                                onTap: () {
                                  //print('Container tapped');
                                  if(seatData['SeatStatus'] == 'available')
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomerCheckout(user: widget.userData,flight: widget.flightData,
                                        seat: seatData,seattype: seatTypeObject,),
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text('The Seat is Reserved'),
                                        );
                                      },
                                    );
                                  }                                 
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
                                          child: Text("${seatData['SeatNumber']}",
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
                                            Text("${seatData['SeatAttribute']}",
                                              style: const TextStyle(
                                                fontSize: 15, 
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${seatData['SeatStatus']}",
                                              style: const TextStyle(
                                                fontSize: 15, 
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${seatData['Discount']}",
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