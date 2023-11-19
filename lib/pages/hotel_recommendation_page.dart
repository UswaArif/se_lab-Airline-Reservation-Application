import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelRecommendation extends StatelessWidget {
  const HotelRecommendation({super.key});

  void _openWebsite() async {
    const String url = 'https://bookme.pk/book-hotels-online';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openCarWebsite() async {
    const String url = 'https://www.avis.com/en/home';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hotel and Car Rentals Recommendations"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                //border: Border.all(),
                //borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(255, 180, 212, 238),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          'Get best Hotel deals',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          'We compare from 1000+ hotel deals worldwide',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _openWebsite(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(width: 1, color: Colors.deepPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), 
                      ),
                    ),
                    child: const Text('Explore', style: TextStyle(color: Colors.deepPurple),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                //border: Border.all(),
                //borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(255, 231, 188, 240)
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          'Get a cheap rental cars',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          'We compare from 100+ rental car providers',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          'world wide',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _openCarWebsite(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(width: 1, color: Colors.deepPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), 
                      ),
                    ),
                    child: const Text('Explore', style: TextStyle(color: Colors.deepPurple),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}