import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/classes/payment_model.dart';
import 'package:se_lab/classes/seats_model.dart';
import 'package:se_lab/classes/ticket_model.dart';
import 'package:se_lab/repository/logtable_repository.dart';
import 'package:se_lab/repository/payment_repository.dart';
import 'package:se_lab/repository/seat_repository.dart';
import 'package:se_lab/repository/ticket_repository.dart';

class CustomerCheckout extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> flight;
  final Map<String, dynamic> seat;
  final Map<String, dynamic> seattype;
  const CustomerCheckout({
    Key? key,
    required this.user, required this.flight, required this.seat, required this.seattype
  }) : super(key: key);


  @override
  State<CustomerCheckout> createState() => _CustomerCheckoutState();
}

class _CustomerCheckoutState extends State<CustomerCheckout> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _passportnumber = TextEditingController();
  final TextEditingController _cnic = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _accountno = TextEditingController();
  bool isLoading = false;
  int price = 0;
  List<Map<String, dynamic>> paymentMethodDataList = [];
  String? selectedPaymentMethod; 
  String? selectedBank; 
  Future<String>? documentId;

  @override
  void initState() {
    super.initState();
    //selectedPaymentMethod = ['Credit', 'Wallet', 'Debit'].first;
    getPaymentMethodData();
    
  }
  
  Future<void> getPaymentMethodData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("PaymentMethod")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        paymentMethodDataList = querySnapshot.docs.map((paymentmethodSnapshot) {
        final data = paymentmethodSnapshot.data() as Map<String, dynamic>;
        final documentId = paymentmethodSnapshot.id; // Get the document ID
        data['documentId'] = documentId; // Add the document ID to the data
        return data;
      }).toList();
      //print(paymentMethodDataList);
        setState(() {});
      } else {
        print("No Payment Method data found in Firestore.");
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      final log = LogTable(
        page_name: "customer_checkout_page",
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

  addTicket() {
    try {
      setState(() {
        isLoading = true;
      });
      // Add Ticket object using your class
      final ticket = TicketModel(
        ticket_buyer_name: _name.text,
        passport_number: int.parse(_passportnumber.text),
        cnic: int.parse(_cnic.text),
        email: _email.text,
        price: price,
        user_id: widget.user['documentID'],
        flight_id: widget.flight['documentId'],
        seat_id: widget.seat['documentId'],
        created_at: Timestamp.now(),
        updated_at: Timestamp.now(),
        active: true,
      );
      final ticketRepository = TicketRepository();
      documentId = ticketRepository.createTicket(context, ticket);
      print("Ticket added Successfully.");

      // Update seat status to 'reserved'
    widget.seat['SeatStatus'] = 'reserved';
    final SeatModel updatedSeat = SeatModel(
      id: widget.seat['documentId'],
      seat_number: widget.seat['SeatNumber'],
      seat_type_id: widget.seat['SeatTypeId'],
      seat_status: 'reserved',
      seat_attribute: widget.seat['SeatAttribute'],
      discount: widget.seat['Discount'],
      flight_id: widget.seat['FlightId'],
      created_at: widget.seat['CreatedAt'],
      updated_at: Timestamp.now(),
      active: widget.seat['Active']
    );

    final seatRepository = SeatRepository();
    seatRepository.updateSeatRecord(updatedSeat);

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
      
      //log table
      final log = LogTable(
        page_name: "customer_checkout_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  addPayment() {
    try {
      setState(() {
        isLoading = true;
      });
      String paymentmethod = '';
      for (Map<String, dynamic> pay in paymentMethodDataList) {     
        if (pay['Type'] == selectedPaymentMethod) {
          paymentmethod =  pay['documentId'];
          break;
        }
      }  
      // Add Payment object using your class
      final payment = PaymentModel(
        user_id: widget.user['documentID'],
        payment_method_id: paymentmethod,
        paid_amount: price,
        ticket_id: documentId.toString(),
        bank_name: selectedBank ?? "HBL",
        account_no: int.parse(_accountno.text),
        payment_status: 'Paid',
        created_at: Timestamp.now(),
        updated_at: Timestamp.now(),
        active: true,
      );
      final paymentRepository = PaymentRepository();
      paymentRepository.createPayment(context, payment);
      print("payment added Sucessfully");

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
      
      //log table
      final log = LogTable(
        page_name: "customer_checkout_page",
        error: e.toString(),
      );
      final logRepository = LogTableRepository();
      // ignore: use_build_context_synchronously
      logRepository.createLog(context, log);
    }
  }

  @override
  Widget build(BuildContext context) {
    price =(widget.flight['Price'] + widget.seattype['Price']) - ((widget.flight['Price'] + widget.seattype['Price'])
     * widget.seat['Discount']/100);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
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
                  child: Text("${widget.flight['FlightNumber']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // You can apply any styling you want
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.flight['Source'],
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.flight_takeoff_outlined,
                      size: 24.0,
                      color: Colors.red,
                    ),
                    Text(
                      widget.flight['Destination'],
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),               
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTimestamp(widget.flight['DepartureTime']),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      _formatTimestamp(widget.flight['ArrivalTIme']),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Seat No: ${widget.seat['SeatNumber']}",
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "${widget.seat['SeatAttribute']}",
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Price: $price",
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note:",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "Excess Baggage Fee will be taken if Baggage weight exceed.",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
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
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            //Ticket Name
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                              child: TextFormField(
                                controller: _name,                          
                                validator: (text){
                                  if(text == null || text.isEmpty){
                                    return 'Name is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person_sharp, color: Colors.white,),
                                  labelText: "Ticket Buyer Name",
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
                            //Passport Number
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                              child: TextFormField(
                                controller: _passportnumber,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10), // Limit input to 10 characters
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                ],
                                keyboardType: TextInputType.number,
                                validator: (text){
                                  if(text == null || text.isEmpty){
                                    return 'Passport Number is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.password, color: Colors.white,),
                                  hintText: 'Passport Number is only 10 digits',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Passport Number",
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
                            //CNIC
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                              child: TextFormField(
                                controller: _cnic,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(13), // Limit input to 10 characters
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                ],
                                keyboardType: TextInputType.number,
                                validator: (text){
                                  if(text == null || text.isEmpty){
                                    return 'CNIC is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person_pin, color: Colors.white,),
                                  hintText: 'CNIC is only 13 digits',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "CNIC",
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
                            //Email
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                              child: TextFormField(
                                controller: _email,                          
                                validator: (text){
                                  if(text == null || text.isEmpty){
                                    return 'Email is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email, color: Colors.white,),
                                  labelText: "Email",
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
                            //Payment Method
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.payments_outlined, color: Colors.white),
                                      labelText: 'Payment Method',
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
                                    value: selectedPaymentMethod,
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedPaymentMethod = newValue!;
                                        //print(selectedSeatType);
                                      });
                                    },
                                    items: <String>['Credit', 'Wallet', 'Debit']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a payment method';
                                      }
                                      return null;
                                    },
                                  ),                
                                ],
                              ),
                            ),
                            //Bank Name
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.account_balance, color: Colors.white),
                                      labelText: 'Bank',
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
                                    value: selectedBank,
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedBank = newValue!;
                                        //print(selectedSeatType);
                                      });
                                    },
                                    items: <String>['HBL', 'Soneri', 'Allied']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a Bank name';
                                      }
                                      return null;
                                    },
                                  ),                
                                ],
                              ),
                            ),
                            //Account no
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                              child: TextFormField(
                                controller: _accountno,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11), // Limit input to 11 characters
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                ],
                                keyboardType: TextInputType.number,
                                validator: (text){
                                  if(text == null || text.isEmpty){
                                    return 'Account No. is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle, color: Colors.white,),
                                  hintText: 'Account Number is only 11 digits',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Account No.",
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
                                      if (_passportnumber.text.length == 10 && _cnic.text.length == 13 && _accountno.text.length == 11)
                                      {
                                        addTicket();  
                                        addPayment();
                                      } 
                                      else{
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Invalid Passport Number'),
                                              content: const Text('Check your Passport number or CNIC.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }                                                                                                
                                    } 
                                  },                                 
                                  child: isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                  )
                                  : const Text('Check out'),
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
          ),
          
        ],
      ),
    );
  }
}