import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapComponent extends StatefulWidget {
  final String startAddress;
  final String destinationAddress;

  const MapComponent({
    Key? key,
    required this.startAddress,
    required this.destinationAddress,
  }) : super(key: key);

  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = Set<Polyline>();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getDirections();
  }

  Future<void> _getDirections() async {
    List<Location> startLocations =
        await locationFromAddress(widget.startAddress);
    List<Location> destinationLocations =
        await locationFromAddress(widget.destinationAddress);

    if (startLocations.isNotEmpty && destinationLocations.isNotEmpty) {
      LatLng startLatLng =
          LatLng(startLocations.first.latitude, startLocations.first.longitude);
      LatLng destinationLatLng = LatLng(destinationLocations.first.latitude,
          destinationLocations.first.longitude);

      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${startLatLng.latitude},${startLatLng.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}&key=YOUR_API_KEY';
      http.Response response = await http.get(Uri.parse(url));
      Map data = json.decode(response.body);
      List<LatLng> polylineCoordinates =
          _decodePoly(data['routes'][0]['overview_polyline']['points']);

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            visible: true,
            points: polylineCoordinates,
            width: 4,
            color: Colors.blue,
          ),
        );
      });
    }
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> poly = [];
    var index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Default position
          zoom: 12.0,
        ),
        polylines: _polylines,
      ),
    );
  }
}
