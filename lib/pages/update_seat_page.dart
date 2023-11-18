import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_lab/classes/seats_model.dart';
import 'package:se_lab/repository/seat_repository.dart';

class UpdateSeat extends StatefulWidget {
  final Map<String, dynamic> seatData;
  const UpdateSeat({
    Key? key,
    required this.seatData,
  }) : super(key: key);
  @override
  State<UpdateSeat> createState() => _UpdateSeatState();
}

class _UpdateSeatState extends State<UpdateSeat> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _seatnumber = TextEditingController();
  final TextEditingController _seatattribute = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  String? selectedSeatType; 
  String selectedSeatStatus = 'available'; 
  bool isLoading = false;
  List<Map<String, dynamic>> SeatTypeDataList = [];
  String? SeatTypeName;
  final seatRepository = SeatRepository();

  @override
  void initState() {
    super.initState();
    getSeatTypeData();
    print(widget.seatData);
    // Set initial values based on flightData
    _seatnumber.text = widget.seatData['SeatNumber'].toString();
    selectedSeatType = widget.seatData['SeatType'];
    _seatattribute.text = widget.seatData['SeatAttribute'];
    //selectedSeatStatus = widget.seatData['SeatStatus'];
    _discount.text = widget.seatData['Discount'].toString();
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
      for (Map<String, dynamic> seat in SeatTypeDataList) {     
        if (seat['documentId'] == widget.seatData['SeatTypeId']) {
          selectedSeatType = seat['Name'];
          print("Seat Type Name is matched");
          break;
        }
      }
        //print(flightDataList);
        // Force a rebuild to display the flight data
        setState(() {});
      } else {
        print("No Seat Type data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }
  updateSeat(SeatModel seat) async{
    try{
      await seatRepository.updateSeatRecord(seat);
      print("updateFlight");
    } catch (e) {
      print(e);
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
                "Update Seat",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                height: 400,
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
                      //Seat status
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.event_available, color: Colors.white),
                                labelText: 'Seat Status',
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
                              value: selectedSeatStatus,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSeatStatus = newValue!;
                                  //print(selectedSeatType);
                                });
                              },
                              items: <String>['available', 'reserved']
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
                                if (_formKey2.currentState!.validate()) {
                                  String seatTypeId = 'null';
                                  for (Map<String, dynamic> seat in SeatTypeDataList) {     
                                    if (seat['Name'] == selectedSeatType) {
                                      seatTypeId = seat['documentId'];
                                      break;
                                    }
                                  }
                                  Timestamp createdAt = widget.seatData['CreatedAt'];
                                  String flightId = widget.seatData['FlightId'];
                                  final seat = SeatModel(
                                    id: widget.seatData['documentId'],
                                    seat_number: int.parse(_seatnumber.text),
                                    seat_attribute: _seatattribute.text,                                   
                                    seat_type_id: seatTypeId,
                                    seat_status: selectedSeatStatus,
                                    discount: int.parse(_discount.text),
                                    flight_id: flightId,
                                    created_at: createdAt,
                                    updated_at: Timestamp.now(),
                                    active: true,
                                  );
                                  //print(flight.flight_number);
                                  updateSeat(seat);                                    
                                } 
                              },
                              
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              )
                              : const Text('Update Seat'),
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