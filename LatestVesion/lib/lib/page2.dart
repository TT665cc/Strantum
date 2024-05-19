import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Training",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/nav1.png',
              height: 50,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Search Page',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
