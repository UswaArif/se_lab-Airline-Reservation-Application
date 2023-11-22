import 'package:flutter/material.dart';

class RulesBaggage extends StatelessWidget {
  const RulesBaggage({Key? key});

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        const Text('• ', style: TextStyle(fontSize: 16)),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("BAGGAGE RULES AND RESTRICTIONS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView( // Wrap the Column with a ListView
          children: [
            const Text(
              'For the safety of our passengers and aircraft, passengers are prohibited from carrying the following items in either checked or hand baggage:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBulletPoint('Explosives, munitions, fireworks, and flares'),
            _buildBulletPoint(
                'Security-type cases/boxes incorporating goods such as lithium batteries or pyrotechnics'),
            _buildBulletPoint(
                'Compressed gases (flammable, non-flammable, or poisonous) such as butane, propane, aqualung cylinders, lighter fuels, or refills'),
            // Add more bullet points for other prohibited items...

            const SizedBox(height: 20),

            const Text(
              'Lighters (butane, absorbed fuel, electric, battery-powered, and novelty lighters) are not to be carried in the carry-on and checked baggage. This ruling by The Transportation Security Administration (TSA) applies to all passengers arriving into or departing from the United States of America.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const Text(
              'In addition, passengers are not allowed to carry the following items in their hand baggage for passengers’ safety and security reasons. To minimize inconvenience, you are advised to check in or put these items in your checked baggage instead:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBulletPoint('Knives (including hunting knives, swords, and pocket knives)'),
            _buildBulletPoint('Scissors and any other sharp/bladed objects (e.g. ice-pick, nail clippers) considered illegal by local law.'),
            // Add more bullet points for other prohibited items...

            const SizedBox(height: 20),

            const Text(
              'Do ensure that all your bags are properly labeled, both inside and outside. Include your full name, home and destination addresses and telephone contact information, and remove old destination tags and labels.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}