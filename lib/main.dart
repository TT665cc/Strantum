import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'gpx_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPX Parser Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _coordinates = 'No data';
  String _altitudes = 'No data';

  void _fetchGpxData() async {
    final gpxData = await GpxParser().fetchGpxData();
    setState(() {
      _coordinates = gpxData['coordinates'].toString();
      _altitudes = gpxData['altitudes'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPX Parser Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchGpxData,
              child: Icon(Icons.bluetooth),
            ),
            SizedBox(height: 20),
            Text('Coordinates: $_coordinates'),
            SizedBox(height: 20),
            Text('Altitudes: $_altitudes'),
          ],
        ),
      ),
    );
  }
}
