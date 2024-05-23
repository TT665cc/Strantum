import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiniMap extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  const MiniMap({required this.startPoint, required this.endPoint, Key? key})
      : super(key: key);

  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final response = await http.get(Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62489da2a953f86c4a8a8b89f969b35dc233&start=${widget.startPoint.longitude},${widget.startPoint.latitude}&end=${widget.endPoint.longitude},${widget.endPoint.latitude}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['features'] != null && data['features'].isNotEmpty) {
        List<LatLng> points = [];
        for (var point in data['features'][0]['geometry']['coordinates']) {
          points.add(LatLng(point[1], point[0]));
        }

        setState(() {
          routePoints = points;
        });
      } else {
        print("No route found in the response.");
      }
    } else {
      print("Failed to load route: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Ajustez le rayon pour obtenir l'effet souhaité
      child: FlutterMap(
        options: MapOptions(
          center: widget.startPoint,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/outdoor-v2/{z}/{x}/{y}.png?key=p5Pl3ScNixiIcHtiWKi6',
            additionalOptions: {
              'key': 'p5Pl3ScNixiIcHtiWKi6',
            },
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
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: widget.endPoint,
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
