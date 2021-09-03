import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';

Future<Position> getCurrentPosition() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  return position;
}

getCurrentPlaceName(Position position) async {
  var googleGeocoding =
      GoogleGeocoding("AIzaSyC92UARV7HJsL0iq2jMsue7JMQJeg2LBcE");
  await googleGeocoding.geocoding
      .getReverse(LatLon(
    position.latitude,
    position.longitude,
  ))
      .then((value) {
    value.results.forEach((element) {
      print("Area is ${element}");
    });
    print("Result ${value.results.first.formattedAddress}");
  });
}
