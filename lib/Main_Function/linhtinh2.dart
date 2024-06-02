import 'package:flutter/material.dart';
import 'package:location/location.dart' as LocationPlugin;
import 'package:geocoding/geocoding.dart' as GeocodingPlugin;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationPlugin.LocationData? _currentPosition;
  String _currentAddress = '';
  LocationPlugin.Location location = LocationPlugin.Location();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  _checkPermissions() async {
    bool _serviceEnabled;
    LocationPlugin.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LocationPlugin.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != LocationPlugin.PermissionStatus.granted) {
        return;
      }
    }
  }

  _getCurrentLocation() async {
    try {
      LocationPlugin.LocationData locationData = await location.getLocation();
      setState(() {
        _currentPosition = locationData;
      });

      _getAddressFromLatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      print("Error: $e");
    }
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<GeocodingPlugin.Placemark> placemarks = await GeocodingPlugin.placemarkFromCoordinates(latitude, longitude);
      GeocodingPlugin.Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                  "LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}"),
            if (_currentAddress.isNotEmpty)
              Text("Address: $_currentAddress"),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}
