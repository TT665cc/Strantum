import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowItineraire extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  ShowItineraire({required this.startPoint, required this.endPoint});

  @override
  _ShowItineraireState createState() => _ShowItineraireState();
}

class _ShowItineraireState extends State<ShowItineraire> {
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    final route = await getRoute(widget.startPoint, widget.endPoint);
    setState(() {
      routePoints = route;
    });
  }

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> route = (data['routes'][0]['geometry']['coordinates'] as List)
          .map((coord) => LatLng(coord[1], coord[0]))
          .toList();
      return route;
    } else {
      throw Exception('Failed to load route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: widget.startPoint,
          zoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
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
                point: widget.startPoint,
                builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.endPoint,
                builder: (ctx) => Icon(Icons.location_on, color: Colors.green, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
