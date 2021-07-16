import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllMarkerMapPage extends StatefulWidget {
  List sortedList;
  Set<Marker> markers = {};

  AllMarkerMapPage({this.sortedList, this.markers});

  @override
  State<AllMarkerMapPage> createState() => AllMarkerMapPageState(
        markers: this.markers,
        sortedList: this.sortedList,
      );
}

class AllMarkerMapPageState extends State<AllMarkerMapPage> {
  List sortedList;
  Set<Marker> markers;

  AllMarkerMapPageState({this.sortedList, this.markers}) {}

  LatLng myCurrentPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("All places Markers"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Align(
              alignment: Alignment.center,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: this.markers.first.position,
                  zoom: 16,
                ),
                trafficEnabled: true,
                buildingsEnabled: true,

                mapType: MapType.normal,
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
                        ),
                      },
                onMapCreated: (GoogleMapController controller) {},
                // compassEnabled: true,
                // onMapCreated:
              ),
            ),
          ),
        ),
      ),
    );
  }
}
