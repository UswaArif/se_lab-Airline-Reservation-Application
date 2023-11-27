import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_lab/classes/baggage_model.dart';
import 'package:se_lab/classes/log_table.dart';
import 'package:se_lab/repository/baggage_repository.dart';
import 'package:se_lab/repository/logtable_repository.dart';

class UpdateBaggage extends StatefulWidget {
  final Map<String, dynamic> updatebaggageData;
  const UpdateBaggage({
    Key? key,
    required this.updatebaggageData,
  }) : super(key: key);

  @override
  State<UpdateBaggage> createState() => _UpdateBaggageState();
}

class _UpdateBaggageState extends State<UpdateBaggage> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _seatclass = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _bagcounts = TextEditingController();
  final TextEditingController _sizerestriction = TextEditingController();
  final TextEditingController _excessbaggagefee = TextEditingController();
  bool isLoading = false;
  final baggageRepository = BaggageRepository();

  @override
  void initState() {
    super.initState();
    _seatclass.text = widget.updatebaggageData['SeatTypeClass'];
    _weight.text = widget.updatebaggageData['WeightperKg'].toString();
    _bagcounts.text = widget.updatebaggageData['BagCounts'].toString();
    _sizerestriction.text = widget.updatebaggageData['SizeRestriction'];
    _excessbaggagefee.text = widget.updatebaggageData['ExcessBaggageFeePerKg'].toString();
  }

  updateBaggageData(BaggageModel baggage) async{
    try{
      await baggageRepository.updateBaggageRecord(baggage);
      print("updateBaggage");
    } catch (e) {
      print(e);
      //log table
      final log = LogTable(
        page_name: "update_baggage_page",
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
                "Update Baggage",
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
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      //Seat Class Not editable
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          enabled: false, // Set the TextFormField as disabled
                          controller: _seatclass,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.airline_seat_recline_extra, color: Colors.white),
                            labelText: "Seat Class",
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
                      //Baggage weight
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _weight,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Baggage weight is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monitor_weight, color: Colors.white,),
                            labelText: "Baggage Weight in Kgs",
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
                      //Bag Counts
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _bagcounts,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Bags count is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.numbers, color: Colors.white,),
                            labelText: "Number of Bag counts",
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
                      //Size Restrictions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _sizerestriction,                          
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Size Restrictions is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.width_normal, color: Colors.white,),
                            labelText: "Size Restrictions in lengthxwidthxheight cm",
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
                      //Excess Baggage fee
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add left and right margin
                        child: TextFormField(
                          controller: _excessbaggagefee,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                          ],
                          keyboardType: TextInputType.number,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Excess Baggage Fee is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.money_off, color: Colors.white,),
                            labelText: "Excess Baggage Fee in Kgs",
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
                                  Timestamp createdAt = widget.updatebaggageData['CreatedAt'];                                
                                  final bag = BaggageModel(
                                    id: widget.updatebaggageData['documentId'],
                                    seat_type_class: widget.updatebaggageData['SeatTypeClass'],
                                    weight_per_kg: int.parse(_weight.text),
                                    bag_counts: int.parse(_bagcounts.text),                                   
                                    size_restriction: _sizerestriction.text,
                                    excess_baggage_fee_per_kg: int.parse(_excessbaggagefee.text),                                    
                                    created_at: createdAt,
                                    updated_at: Timestamp.now(),
                                    active: true,
                                  );
                                  updateBaggageData(bag);                                 
                                }
                              },
                              
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              )
                              : const Text('Update Baggage'),
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