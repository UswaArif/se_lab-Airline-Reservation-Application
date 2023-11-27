import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("About Us"),
        backgroundColor: Color.fromARGB(255, 94, 171, 199),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/download.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          const Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,             
              children: <Widget>[
                SizedBox(height: 30,),
                Text(
                  'MY AIRLINE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version: 1.9.5',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25,),
                Text(
                  'We compare all the top travel sites in one',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'simple search and help you find the best flight',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'and hotel deals. As a travel metasearch engine,',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'we do not sell tickets. The booking happens in',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'respective online travel agent websites.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                // Add more Text widgets as needed
              ],
            ),
          )

        ],
      )



    );
  }
}