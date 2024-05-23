import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'minimap.dart'; // Assurez-vous que le chemin est correct

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
              routePoints: [
                LatLng(51.5, -0.09),
                LatLng(52.505, -0.08),
                LatLng(51.51, -0.07),
                LatLng(51.515, -0.06),
                LatLng(51.52, -0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
