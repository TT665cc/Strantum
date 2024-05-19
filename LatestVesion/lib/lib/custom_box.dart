import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final int distance;
  final int altitude;
  final int speed;

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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Image.asset('assets/images/desc1.png', height: 16),
              const SizedBox(width: 4),
              Text('$distance km', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 16),
              Image.asset('assets/images/desc2.png', height: 16),
              const SizedBox(width: 4),
              Text('$altitude m', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 16),
              Image.asset('assets/images/desc3.png', height: 16),
              const SizedBox(width: 4),
              Text('$speed m', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8.0),
          Image.asset(imagePath),
        ],
      ),
    );
  }
}
