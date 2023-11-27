import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/pages/about_us_page.dart';
import 'package:se_lab/pages/add_flight_page.dart';
import 'package:se_lab/pages/customer_seat_page.dart';
import 'package:se_lab/pages/customer_view_tickets_page.dart';
import 'package:se_lab/pages/feedback_page.dart';
import 'package:se_lab/pages/hotel_recommendation_page.dart';
import 'package:se_lab/pages/llogin_page.dart';
import 'package:se_lab/repository/logtable_repository.dart';
import 'package:se_lab/widgets/customer_drawer.dart';

class CustomerHomePage extends StatefulWidget {
  final Map<String, dynamic> UserData;
  const CustomerHomePage({
    Key? key,
    required this.UserData,
  }) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _customerPageState();
}

class _customerPageState extends State<CustomerHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _toController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  List<Map<String, dynamic>> flightDataList = [];
  String? selectedSource;
  bool isMatchFound = false;
  List<Map<String, dynamic>> matchedflightList = [];
  bool showAdditionalWidget = false; 
  List<bool> seatHoverStates = [];

  @override
  void initState() {
    super.initState();
    // Call the function to get flight data from Firebase when the widget is initialized
    getFlightData();
  }

  Future<void> getFlightData() async {
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
        // Force a rebuild to display the flight data
        setState(() {});
      } else {
        print("No flight data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      //log table
      final log = LogTable(
        page_name: "customer_home_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    //final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    final DateFormat format = DateFormat('MMMM d, HH:mm');
    final String formattedDateTime = format.format(dateTime);
    return formattedDateTime;
  }

  void _openDrawer() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  List<Map<String, dynamic>> removeDuplicates(
    List<Map<String, dynamic>> list, String key) {
    Map<dynamic, Map<String, dynamic>> map = {};
    list.forEach((element) {
      final value = element[key];
      if (!map.containsKey(value)) {
        map[value] = element;
      }
    });
    return map.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Customer Home Page"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          IconButton(
            onPressed: ()async {
              try {
                await FirebaseAuth.instance.signOut();
                print("DOne");
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with the actual name of your sign-up page class
                        );
                // Redirect or perform other actions after successful sign-out.
              } catch (e) {
                print("Error during sign out: $e");
                // Handle the error as needed.
              }
            },
            icon: const Icon(Icons.login),
            ),
        ],
      ),
      drawer: CustomerDrawer( 
        // Use the CustomerDrawer widget as drawer
        user: widget.UserData,
        onProfileTap: () {
          Navigator.of(context).pop();
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFlight()), 
          );*/
        },
        onTap2: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerAllTicket(user: widget.UserData,)), 
          );
        },
        onTap3: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedbackCustomer(user: widget.UserData,)), 
          );
        },
        onTap4: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HotelRecommendation()), 
          );
        },
        onTap5: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Aboutus()), 
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TypeAheadFormField<Map<String, dynamic>>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _toController,
                          decoration: const InputDecoration(
                            labelText: 'Source',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        suggestionsCallback: (String pattern) {
                          List<Map<String, dynamic>> filteredList = flightDataList
                              .where((flight) =>
                                  flight['Source'].toLowerCase().contains(pattern.toLowerCase()))
                              .toList();

                          // Deduplicate the filtered list based on the 'Source' key
                          List<Map<String, dynamic>> deduplicatedList = removeDuplicates(filteredList, 'Source');

                          return deduplicatedList;
                        },
                        itemBuilder: (BuildContext context, Map<String, dynamic> suggestion) {
                          return ListTile(
                            title: Text(suggestion['Source']),
                          );
                        },
                        onSuggestionSelected: (Map<String, dynamic> suggestion) {
                          setState(() {
                            _toController.text = suggestion['Source'];
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a source';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20), // Space between text fields and icon
                    const Icon(Icons.arrow_circle_right_rounded),
                    const SizedBox(width: 20), // Space between icon and text fields
                    Expanded(
                      child: TypeAheadFormField<Map<String, dynamic>>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            labelText: 'Destination',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        suggestionsCallback: (String pattern) {
                          List<Map<String, dynamic>> filteredList = flightDataList
                              .where((flight) =>
                                  flight['Destination'].toLowerCase().contains(pattern.toLowerCase()))
                              .toList();

                          // Deduplicate the filtered list based on the 'Source' key
                          List<Map<String, dynamic>> deduplicatedList = removeDuplicates(filteredList, 'Destination');

                          return deduplicatedList;
                        },
                        itemBuilder: (BuildContext context, Map<String, dynamic> suggestion) {
                          return ListTile(
                            title: Text(suggestion['Destination']),
                          );
                        },
                        onSuggestionSelected: (Map<String, dynamic> suggestion) {
                          setState(() {
                            _destinationController.text = suggestion['Destination'];
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a destination';
                          }
                          return null;
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      matchedflightList.clear();   
                      for (Map<String, dynamic> flightData in flightDataList) {  
                        
                        if (flightData['Source'] == _toController.text && flightData['Destination'] == _destinationController.text) {
                          isMatchFound = true;  
                          matchedflightList.add(flightData);                     
                          print("Flight is matched");
                          //break;
                        }                        
                      }                   
                    }
                    //print(matchedflightList);
                    if (matchedflightList.isNotEmpty) {
                      setState(() {
                        showAdditionalWidget = true;
                      });
                    }
                    else{                            
                      print("No flight available");
                      setState(() {
                        showAdditionalWidget = false; // Hiding additional widget if no match found
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('No flight is available of this Source and Destination'),
                          );
                        },
                      );
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
                          itemCount: matchedflightList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final flightData = matchedflightList[index];
                            if (seatHoverStates.length <= index) {
                              seatHoverStates.add(false);
                            }
                            return GestureDetector(
                              onTap: () {
                                print('Container tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerSeatPage(userData: widget.UserData,flightData: flightData,),
                                  ),
                                );
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
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}