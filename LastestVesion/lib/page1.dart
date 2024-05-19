import 'package:flutter/material.dart';
import 'custom_box.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Strantum",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/fire.png',
              height: 44,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          CustomBox(
            title: 'Course en soirée',
            description: 'Ceci est une description de la boîte.',
            imagePath: 'assets/images/map1.png',
            distance: 21,
            altitude: 200,
            speed: 15,
          ),
          SizedBox(height: 16.0),
          CustomBox(
            title: 'Balade matinale',
            description: 'Ceci est une autre description de la boîte.',
            imagePath: 'assets/images/map2.png',
            distance: 3,
            altitude: 100,
            speed: 10,
          ),
          SizedBox(height: 16.0),
          CustomBox(
            title: 'Voyage en montagne',
            description: 'Une description supplémentaire pour la boîte.',
            imagePath: 'assets/images/map3.png',
            distance: 7,
            altitude: 300,
            speed: 12,
          ),
        ],
      ),
    );
  }
}
