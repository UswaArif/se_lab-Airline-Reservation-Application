import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:se_lab/classes/flight_model.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/flight_repository.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class UpdateFlightPage extends StatefulWidget {
  final Map<String, dynamic> flightData;
  const UpdateFlightPage({
    Key? key,
    required this.flightData,
  }) : super(key: key);

  //const UpdateFlightPage({super.key, required Map<String, dynamic> flightData});

  @override
  State<UpdateFlightPage> createState() => _updateFlightState();
}

class _updateFlightState extends State<UpdateFlightPage> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _flightnumber = TextEditingController();
  final TextEditingController _source = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _availableseats = TextEditingController();
  final TextEditingController _flightstatus = TextEditingController();
  bool _isDelayed = false;
  bool _isOnTime = false;
  bool isLoading = false;
  String ontime = "On Time";
  final flightRepository = FlightRepository();

  @override
  void initState() {
    super.initState();
    print(widget.flightData);
    // Set initial values based on flightData
    _flightnumber.text = widget.flightData['FlightNumber'].toString();
    _source.text = widget.flightData['Source'];
    if(widget.flightData['Destination'] != null)
    {
      _destination.text = widget.flightData['Destination'];
    }
    else{
      _destination.text = "null";
    }
    // Format date and time to string for departure and arrival fields
    _departure.text = DateFormat('yyyy-MM-dd HH:mm').format(widget.flightData['DepartureTime'].toDate());
    _arrival.text = DateFormat('yyyy-MM-dd HH:mm').format(widget.flightData['ArrivalTIme'].toDate());
    _price.text = widget.flightData['Price'].toString();
    _availableseats.text = widget.flightData['AvailableSeats'].toString();
    // Check the flight status to set the checkboxes
    if (widget.flightData['FlightStatus'] == 'On Time') {
      _isOnTime = true;
    } else if (widget.flightData['FlightStatus'] == 'Delayed') {
      _isDelayed = true;
    }
  }

  DateTime? selectedDateTime; // Store the selected date and time
  
  timegiven()async{
    TimeOfDay? pickedTime;
    DateTime? pickerdate = await showDatePicker(
    context: context, 
    initialDate: DateTime.now(), 
    firstDate: DateTime(2000), 
    lastDate: DateTime(2101)
    );
    // Show the time picker
    if (pickerdate != null) {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }
  

    if(pickerdate != null && pickedTime != null){
      // Combine the selected date and time into a single DateTime object
      DateTime selectedDateTime = DateTime(
        pickerdate.year,
        pickerdate.month,
        pickerdate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Now you can use selectedDateTime, which contains both date and time.
      _departure.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
    }
  }

  timegiven2()async{
    TimeOfDay? pickedTime;
    DateTime? pickerdate = await showDatePicker(
    context: context, 
    initialDate: DateTime.now(), 
    firstDate: DateTime(2000), 
    lastDate: DateTime(2101)
    );
    // Show the time picker
    if (pickerdate != null) {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }
  

    if(pickerdate != null && pickedTime != null){
      // Combine the selected date and time into a single DateTime object
      DateTime selectedDateTime = DateTime(
        pickerdate.year,
        pickerdate.month,
        pickerdate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Now you can use selectedDateTime, which contains both date and time.
      _arrival.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
    }
  }

  updateFlight(FlightModel flight) async{
    try{
      await flightRepository.updateFlightRecord(flight);
    //print("updateFlight");
    } catch (e) {
      print(e);
      //log table
      final log = LogTable(
        page_name: "update_flight_page",
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
            alignment:  Alignment.centerLeft, // Align "Add Flight" text to the left
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Update Flight",
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
                height: 700, // Adjust the height as needed
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _flightnumber,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Flight Number is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight, color: Colors.white,),
                            labelText: "Flight No.",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _source,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Source Place is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight_takeoff, color: Colors.white,),
                            labelText: "From",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _destination,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Destination Place is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.flight_land, color: Colors.white,),
                            labelText: "To",
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

                      //Datetime fields
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _departure,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Departure Date is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white,),
                            labelText: "Select Departure Date",
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
                          onTap: () {
                            timegiven();
                          },
                        ),
                      ),
                      //Arrival datetime
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _arrival,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Arrival Date is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white,),
                            labelText: "Select Arrival Date",
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
                          onTap: (){
                            timegiven2();
                          },
                        ),
                      ),
                      //Price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _price,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Price is empty';
                            } else if (double.tryParse(text) == null || double.parse(text) < 0) {
                              return 'Please enter a valid non-negative number';
                            }
                              return null;
                          },
                          keyboardType: TextInputType.number, // Allow only numeric input
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Allow only positive numbers with up to 2 decimal places
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.price_change, color: Colors.white),
                            labelText: "Price",
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
                      //Seats numbers
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _availableseats,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Available Seats is empty';
                            } else if (double.tryParse(text) == null || double.parse(text) < 0) {
                              return 'Please enter a valid non-negative number';
                            }
                            else if (text.contains('.')) {
                              // Check for points (decimal separators)
                              return 'Available Seats should not contain points';
                            }
                              return null;
                          },
                          keyboardType: TextInputType.number, // Allow only numeric input
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Allow only positive numbers with up to 2 decimal places
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.airline_seat_recline_extra, color: Colors.white),
                            labelText: "Available Seats",
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
                      // Flight Status
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [                         
                            CheckboxListTile(
                              title: const Text(
                                "On Time",
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _isOnTime,
                              onChanged: (bool? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _isOnTime = newValue;
                                    _isDelayed = false; // Ensure only one checkbox is selected
                                    // Store the selected status in the controller
                                    _isOnTime = true;
                                    //_flightstatus.text = _isOnTime ? 'On Time' : '';
                                  });
                                }                               
                              },
                              activeColor: Colors.transparent,
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: const Icon(
                                Icons.check,
                                color: Colors.deepPurple,
                              ),
                            ),     

                            CheckboxListTile(
                              title: const Text(
                                "Delayed",
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _isDelayed,
                              onChanged: (bool? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _isOnTime = false;
                                    _isDelayed = newValue; // Ensure only one checkbox is selected
                                    // Store the selected status in the controller
                                    _isDelayed = true;
                                    _flightstatus.text = _isDelayed ? 'Delayed' : '';
                                  });
                                }                               
                              },
                              activeColor: Colors.transparent,
                              controlAffinity: ListTileControlAffinity.leading,
                              secondary: const Icon(
                                Icons.check,
                                color: Colors.deepPurple,
                              ),
                            ),   
                          ],   
                        ),
                      ),

                                            // Add more TextFormField widgets as needed
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                             
                            onPressed: () {

                              if (_formKey2.currentState!.validate()) {
                                DateTime createdAt = (widget.flightData['CreatedAt'] as Timestamp).toDate();

                                final flight = FlightModel(
                                id: widget.flightData['documentId'],
                                flight_number: int.parse(_flightnumber.text),
                                source_place: _source.text,
                                destination_place: _destination.text,
                                //departure: departureTimestamp,
                                departure: DateTime.parse(_departure.text),
                                arrival: DateTime.parse(_arrival.text),
                                price: int.parse(_price.text),
                                available_seats: int.parse(_availableseats.text),
                                flight_status: ontime,
                                created_at: createdAt,
                                updated_at: DateTime.now(),
                                active: true,
                                );
                                print(flight.flight_number);
                                updateFlight(flight);                                   
                              } 
                            },
                            
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                            )
                            : const Text('Update Flight'),
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