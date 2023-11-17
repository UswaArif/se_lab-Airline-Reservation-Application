import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_lab/pages/add_seat2_page.dart';



class AddSeat extends StatefulWidget {
  const AddSeat({super.key});

  @override
  State<AddSeat> createState() => _AddSeatPageState();
}
class _AddSeatPageState extends State<AddSeat> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightnumber = TextEditingController();
  List<Map<String, dynamic>> flightDataList = [];
  bool isMatchFound = false;

  @override
  void initState() {
    super.initState();
    // Call the function to get flight data from Firebase when the widget is initialized
    getFlightNumber();
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
        // Force a rebuild to display the flight data
        
      
        setState(() {});
      } else {
        print("No flight data found in Firestore.");
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
        title: const Text("Flight Number for Seats"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40), 
            TextFormField(
              controller: _flightnumber,
              validator: (text){
                if(text == null || text.isEmpty){
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
            const SizedBox(height: 20), 
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
              onPressed: () {
                Map<String, dynamic>? flightDataa;
                // Add functionality for the button press here
                for (Map<String, dynamic> flightData in flightDataList) {     
                if (flightData['FlightNumber'] == int.tryParse(_flightnumber.text)) {
                  isMatchFound = true;
                  flightDataa = flightData;
                  print("Flight Number is matched");
                  break;
                }
                else{
                  isMatchFound = false;
                }
              }
                if (isMatchFound) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeatPage2(flightData: flightDataa ?? {})), // Replace SeatPage() with your actual SeatPage widget
                  );
                }
                else{
                  print("No match found");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('No match found in flight data'),
                      );
                    },
                  );
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
            
          ],
        ),
      ),  
    );
  }
}