import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/classes/seats_model.dart';
import 'package:se_lab/repository/logtable_repository.dart';
import 'package:se_lab/repository/seat_repository.dart';

class SeatPage2 extends StatefulWidget {
  final Map<String, dynamic> flightData;
  const SeatPage2({
    Key? key,
    required this.flightData,
  }) : super(key: key);
  @override
  State<SeatPage2> createState() => _SeatPage2State();
}

class _SeatPage2State extends State<SeatPage2> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _seatnumber = TextEditingController();
  final TextEditingController _seatattribute = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  String? selectedSeatType; 
  bool isLoading = false;
  List<Map<String, dynamic>> SeatTypeDataList = [];
  @override
  void initState() {
    super.initState();
    // Call the function to get Seat Type data from Firebase when the widget is initialized
    getSeatTypeData();
  }

  Future<void> getSeatTypeData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("SeatType")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        SeatTypeDataList = querySnapshot.docs.map((seatSnapshot) {
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
      //////////////////log table /////////////////////////
      final log = LogTable(
        page_name: "add_seat2_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  addSeatType() {
    try {
      setState(() {
        isLoading = true;
      });
      String SeatTypeId = "null";
      for (Map<String, dynamic> seatTypeData in SeatTypeDataList) {   
        if (seatTypeData['Name'] == selectedSeatType) {
          SeatTypeId = seatTypeData['documentId'];
          //print("seat type is matched");
          break;
        }
      }
      // Add Seat Type object using your class
      final seat = SeatModel(
        seat_number: int.parse(_seatnumber.text),
        seat_type_id: SeatTypeId,
        seat_status: "available",
        seat_attribute: _seatattribute.text,
        discount: int.parse(_discount.text),
        flight_id: widget.flightData['documentId'],
        created_at: Timestamp.now(),
        updated_at: Timestamp.now(),
        active: true,
      );
      print(SeatTypeId);
      // Call the createFlight method from FightRepository to store flight data
      final seatRepository = SeatRepository();
      seatRepository.createSeat(context,seat);
      print("Seat added Successfully.");

      setState(() {
        isLoading = false;
      });  
    } 
    catch (e) {
      setState(() {
        isLoading = false;
        print("Not done");
      });
      print("here is error");
      print(e);
      //////////////////log table /////////////////////////
      final log = LogTable(
        page_name: "add_seat2_page",
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
          const Align(
            alignment:  Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Add Seat",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
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
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      //Seat Number
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _seatnumber,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Seat Number is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.airline_seat_recline_extra, color: Colors.white,),
                            labelText: "Seat No.",
                            labelStyle: TextStyle(
                              color: Colors.white, // Set the text color to white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when focused
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when enabled
                            ),
                          ),
                        ),
                      ),
                      //Seat Type
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.airline_seat_recline_normal_outlined, color: Colors.white),
                                labelText: 'Seat Type',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              value: selectedSeatType,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
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
                          ],
                        ),
                      ),
                      //Seat Attribute
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _seatattribute,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Seat Feature is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.airline_seat_legroom_extra_outlined, color: Colors.white,),
                            labelText: "Seat Feature",
                            labelStyle: TextStyle(
                              color: Colors.white, // Set the text color to white
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when focused
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Set the border color when enabled
                            ),
                          ),
                        ),
                      ),
                      //discount
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          controller: _discount,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow integers and decimals
                          ],
                          keyboardType: TextInputType.numberWithOptions(decimal: true), // Set keyboard type to numeric with decimal
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Discount on Seat is empty';
                            }
                            // You can add additional validation if needed
                            // For instance, check if the entered value meets specific criteria
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.discount, color: Colors.white),
                            labelText: "Discount",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      //Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                             
                            onPressed: () { 
                              print(widget.flightData['documentId']);
                              if (_formKey2.currentState!.validate()) {
                                addSeatType();                                   
                              } 
                            },
                            
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                            )
                            : const Text('Add Seat'),
                          ),
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}