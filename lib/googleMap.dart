import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class MapPage extends StatefulWidget {
  List sortedList;
  Set<Marker> markers = {};

  MapPage({this.sortedList, this.markers}) {
    // print("data of markers is ${markers.first.markerId}");
  }

  @override
  State<MapPage> createState() => MapPageState(
        markers: this.markers,
        sortedList: this.sortedList,
      );
}

class MapPageState extends State<MapPage> {
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   // target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  List sortedList;
  Set<Marker> markers;
  location.Location _location = location.Location();

  MapPageState({this.sortedList, this.markers}) {
    // print("Markers are ${this.markers.first}");
  }

  LatLng myCurrentPosition;

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     // target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  @override
  void initState() {
    // TODO: implement initState
    final Geolocator geolocatorPlatform = Geolocator();
    print("Location is ${geolocatorPlatform}");
    final Future<Position> myCurrent = GeolocatorPlatform.instance
        .getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    )
        .then((Position position) {
      print("POsition is $position");
      setState(() {
        myCurrentPosition = LatLng(position.latitude, position.longitude);
      });
      return position;
    });
    super.initState();

    print("My Current Position is ${myCurrent}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Google Map View"),
        ),
        // body: GoogleMap(
        //   // m
        //   mapType: MapType.normal,

        //   trafficEnabled: true,
        //   myLocationButtonEnabled: true,
        //   indoorViewEnabled: true,

        //   compassEnabled: true,
        //   buildingsEnabled: true,
        //   initialCameraPosition: CameraPosition(
        //     target: LatLng(8.983333, -79.516670),
        //     zoom: 12,
        //   ),
        //   onMapCreated: (GoogleMapController controller) {
        //     _controller.complete(controller);
        //   },
        // ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: Text('To the lake!'),
        //   icon: Icon(Icons.directions_boat),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Align(
              alignment: Alignment.center,
              child: GoogleMap(
                trafficEnabled: true,
                buildingsEnabled: true,
                mapType: MapType.normal,

                // key: ,
                // onTap: (latlng) {
                //   setState(() {
                //     _latCoord.text = latlng.latitude.toString();
                //     _lonCoord.text =
                //         latlng.longitude.toString();
                //   });
                // },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                // onMapCreated: (),
                markers: this.markers != null
                    ? markers
                    : {
                        Marker(
                          markerId: MarkerId("22"),
                          icon: BitmapDescriptor.defaultMarker,
                          draggable: true,
                          onDragEnd: (latLng) {
                            setState(() {
                              myCurrentPosition =
                                  LatLng(latLng.latitude, latLng.longitude);
                            });
                          },
                          position: LatLng(33.5937536, 73.0628096),
                          // position: myCurrentPosition != null
                          //     ? LatLng(myCurrentPosition.latitude,
                          //         myCurrentPosition.latitude)
                          //     : LatLng(
                          //         33.590119,
                          //         73.071545,
                          //       ),
                        ),
                      },
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;

                  // _controller.complete(controller);
                  _location.onLocationChanged.listen((l) {
                    _controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(l.latitude, l.longitude), zoom: 15),
                      ),
                    );
                  });
                },
                zoomControlsEnabled: true,
                compassEnabled: true,

                initialCameraPosition: CameraPosition(
                  target: LatLng(33.540119, 73.071545
                      // double.parse(this.sortedList[0]["lat"]),
                      // double.parse(this.sortedList[0]["lng"]),
                      ),
                  // target: LatLng(8.983333, -79.516670),
                  zoom: 12,
                ),
                // onMapCreated:
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
