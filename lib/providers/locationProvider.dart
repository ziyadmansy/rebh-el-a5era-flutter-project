import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '../exceptions.dart/location_exception.dart';

class LocationProvider with ChangeNotifier {
  String? countryCode;
  String? countryName;

  Future<void> checkLocationPermissions() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw LocationException('GPS Service is disabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw LocationException('Location Permission is denied');
      }
    }
  }

  Future<LocationData> getLocationData() async {
    Location location = Location();
    LocationData _locationData = await location.getLocation();
    return _locationData;
  }

  // Future<void> getCountryCode() async {
  //   final _locationData = await getLocationData();
  //   print('getting coordinates');
  //   final coordinates =
  //       Coordinates(_locationData.latitude, _locationData.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   print(first.countryName);
  //   print(first.countryCode);
  //   countryCode = first.countryCode.toLowerCase();
  //   countryName = first.countryName.toLowerCase();
  //   notifyListeners();
  // }
}
