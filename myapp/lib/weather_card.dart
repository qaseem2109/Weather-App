import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const WeatherCard({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
          
        width: 100,
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 25,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String digit;
  const AdditionalInfoCard(
      {super.key, required this.icon, required this.text, required this.digit});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(
          icon,
          size: 25,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          text,
          style:const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          digit,
          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
