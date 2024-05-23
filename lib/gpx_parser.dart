import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gpx/gpx.dart';
import 'dart:convert';

class GpxParser {
  Future<Map<String, List<double>>> fetchGpxData() async {
    // Vérifiez et demandez les permissions nécessaires
    await Permission.locationWhenInUse.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();

    // Initialisez Bluetooth et connectez-vous à l'appareil
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Commencez à scanner les appareils
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Écoutez les résultats du scan
    var subscription = flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        // Ajoutez la logique pour vous connecter à votre appareil Garmin ici
        // Une fois connecté, récupérez le fichier GPX
      }
    });

    // Arrêtez le scan
    flutterBlue.stopScan();

    // Simuler la lecture d'un fichier GPX pour cette démonstration
    String gpxString = '''
    <gpx>
      <trk>
        <trkseg>
          <trkpt lat="47.644548" lon="-122.326897">
            <ele>4.46</ele>
          </trkpt>
          <trkpt lat="47.644548" lon="-122.326898">
            <ele>4.94</ele>
          </trkpt>
        </trkseg>
      </trk>
    </gpx>
    ''';

    // Parsez le fichier GPX
    final xmlGpx = GpxReader().fromString(gpxString);
    final coordinates = <double>[];
    final altitudes = <double>[];

    for (var track in xmlGpx.trks) {
      for (var segment in track.trksegs) {
        for (var point in segment.trkpts) {
          coordinates.add(point.lat ?? 0);
          coordinates.add(point.lon ?? 0);
          altitudes.add(point.ele ?? 0);
        }
      }
    }

    return {'coordinates': coordinates, 'altitudes': altitudes};
  }
}
