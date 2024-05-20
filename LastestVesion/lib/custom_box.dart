import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final double distance;
  final double altitude;
  final double speed;

  const CustomBox({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.distance,
    required this.altitude,
    required this.speed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins'
            ),
          ),
          const SizedBox(height: 8.0),
          Text(description),
          const SizedBox(height: 8.0),
          Image.asset("assets/images/$imagePath.png"),
          const SizedBox(height: 8.0),
          Text('Distance: $distance km'),
          Text('Altitude: $altitude m'),
          Text('Vitesse: $speed km/h'),
        ],
      ),
    );
  }
}
