import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class Locations {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the Future will return an error.
  Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await Geolocator.openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }

    //When permission is given but GPS is turn off we ask for permission to turn it on
    loc.Location location =
        loc.Location(); //explicit reference to the Location class

    if (!await location.serviceEnabled()) {
      location.requestService();
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.7

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
