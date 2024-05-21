import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_box.dart';
import 'new_activity_page.dart'; // Importez la nouvelle page

class Page1 extends StatelessWidget {
  const Page1({super.key});

  double _convertToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

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
              height: 50,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Activities').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var activities = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activity = activities[index];

              return Column(
                children: [
                  CustomBox(
                    title: activity['title'],
                    description: activity['description'],
                    imagePath: activity['image'],
                    distance: _convertToDouble(activity['distance']),
                    altitude: _convertToDouble(activity['altitude']),
                    speed: _convertToDouble(activity['wind']),
                  ),
                  SizedBox(height: 16.0),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewActivityPage()),
          );
        },
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Carré avec coins arrondis
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
