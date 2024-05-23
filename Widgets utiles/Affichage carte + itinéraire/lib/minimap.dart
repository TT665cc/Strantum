import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiniMap extends StatefulWidget {
  final List<LatLng> routePoints;

  const MiniMap({required this.routePoints, Key? key}) : super(key: key);

  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  @override
  Widget build(BuildContext context) {
    // Si la liste de points est vide, ne pas afficher la carte
    if (widget.routePoints.isEmpty) {
      return Center(child: Text("No route available"));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Ajustez le rayon pour obtenir l'effet souhaité
      child: FlutterMap(
        options: MapOptions(
          center: widget.routePoints.first,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/outdoor-v2/{z}/{x}/{y}.png?key=p5Pl3ScNixiIcHtiWKi6',
            additionalOptions: {
              'key': 'p5Pl3ScNixiIcHtiWKi6',
            },
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.routePoints.first,
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.routePoints.last,
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on, color: Colors.green, size: 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
