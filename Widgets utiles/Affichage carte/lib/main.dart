import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'minimap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter MiniMap Example')),
        body: Center(
          child: Container(
            height: 300, // Taille de la minimap
            width: 300, // Taille de la minimap
            child: MiniMap(
              startPoint: LatLng(51.5, -0.09),
              endPoint: LatLng(51.51, -0.1),
            ),
          ),
        ),
      ),
    );
  }
}
