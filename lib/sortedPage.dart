import 'dart:io';
import 'dart:ui';

// import 'package:firebase/firebase.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locationsort/allMarkers.dart';
import 'package:locationsort/const.dart';
import 'package:locationsort/googleMap.dart';
import 'package:locationsort/routeScreen.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SortedListPage extends StatefulWidget {
  var sortedList;
  SortedListPage({Key key, List sortedList}) {
    // ignore: prefer_initializing_formals
    this.sortedList = sortedList;
  }

  @override
  _SortedListPageState createState() =>
      _SortedListPageState(sortedList: sortedList);
}

class _SortedListPageState extends State<SortedListPage> {
  Set<Marker> _markers = {};
  List sortedList;
  BitmapDescriptor pinLocationIcon;
  bool imageUploading = false;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/layer1.png')
        .then((onvalue) => {pinLocationIcon = onvalue});
    for (var i = 0; i < this.sortedList.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId("${i}"),
          infoWindow: InfoWindow(
              anchor: Offset(0.5, 0),
              title: sortedList[i]["destination"].toString(),
              snippet:
                  "Distance:" + sortedList[i]["miles"].toString() + " Miles"),
          // icon: pinLocationIcon,
          icon: BitmapDescriptor.defaultMarker,

          // icon: Icons.,
          position: LatLng(
            double.parse(sortedList[i]["lat"].toString()),
            double.parse(sortedList[i]["lng"].toString()),
          ),
        ),
      );
      // print("lat ${sortedList[i]["lat"]}");
      // print("lng ${sortedList[i]["lng"]}");
      // print(_markers.iterator.);
    }
    setState(() {});
  }

  _SortedListPageState({this.sortedList}) {
    // print("List is ${sortedList}");
  }

  // final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  // final items = sortedList;

  @override
  Widget build(BuildContext context) {
    final title = 'Sorted PLace';

    return Scaffold(
      // backgroundColor: const Color(0xFFedf6f9),
      backgroundColor: const Color(0xFFe2eafc),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    print("I am calling ${_markers.first.markerId}");
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllMarkerMapPage(
                              markers: _markers,
                              sortedList: this.sortedList,
                            )),
                  );
                },
                child: Text(
                  "Show All Markers",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        // itemCount: items.length,
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          // final item = items[index];
          final item = sortedList[index]["destination"].toString();

          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                // items.removeAt(index);
                sortedList.removeAt(index);
              });

              // Then show a snackbar.
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$item Completed')));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            child: Container(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.all(10),
              // margin: ,
              child: Card(
                elevation: 9,
                color: Color(0xFF3d405b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                // borderOnForeground: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Source Address:",
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sortedList[index]["source"]
                                  .toString()
                                  .split(",")
                                  .first
                                  .toString()
                                  .trim(),
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Destination Address:",
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sortedList[index]["destination"]
                                  .toString()
                                  .split(",")
                                  .first
                                  .toString()
                                  .trim(),
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Distance:",
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sortedList[index]["miles"].toString() + " Miles",
                              style: const TextStyle(
                                color: Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time:",
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              sortedList[index]["time"].toString(),
                              style: TextStyle(
                                color: const Color(0xFFe2eafc),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text("Mark as Complete"),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: InkWell(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.my_location_sharp,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Text(
                                      "Get Route",
                                      style: TextStyle(
                                        // color: Color(0xFFe2eafc),
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Icon(
                                        Icons.exit_to_app_sharp,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  if (kIsWeb) {
                                    MapsLauncher.launchQuery(
                                        sortedList[index]["destination"]);
                                    // '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA');
                                  } else {
                                    setState(() {
                                      selectedCity = sortedList[index];
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MapView(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Set<Marker> singleMarker = {};

                                  setState(() {
                                    singleMarker.add(
                                      Marker(
                                        markerId: MarkerId("${index}"),
                                        icon: BitmapDescriptor.defaultMarker,
                                        position: LatLng(
                                          double.parse(
                                            sortedList[index]["lat"].toString(),
                                          ),
                                          double.parse(
                                            sortedList[index]["lng"].toString(),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapPage(
                                        markers: singleMarker,
                                        sortedList: this.sortedList,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Icon(
                                        Icons.map,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      "Show on Map",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imageUploading
                                  ? CircularProgressIndicator()
                                  : InkWell(
                                      onTap: () async {
                                        final pickedFile = await ImagePicker
                                            .platform
                                            .pickImage(
                                                source: ImageSource.gallery);

                                        if (pickedFile != null) {
                                          setState(() {
                                            imageUploading = true;
                                          });
                                          // FirebaseFirestore.instance.
                                          var image = pickedFile.path;
                                          var testvar = image.toString();
                                          var imageName =
                                              testvar.split("/").last;
                                          var imageExtension =
                                              imageName.substring(
                                                  0, imageName.length - 1);
                                          var imageLink =
                                              "placeImages/${sortedList[index]['destination']}/$imageExtension";

                                          var tempFile = File(pickedFile.path);
                                          var putFile = FirebaseStorage.instance
                                              .ref(imageLink)
                                              .putFile(tempFile);

                                          putFile.whenComplete(() {
                                            FirebaseStorage.instance
                                                .ref(imageLink)
                                                .getDownloadURL()
                                                .then((imageUrl) {
                                              FirebaseFirestore.instance
                                                  .collection("placeImages/")
                                                  .get()
                                                  .then((querySnapshot) {
                                                List data = querySnapshot.docs
                                                    .toList()
                                                    .where((element) => (element
                                                        .id
                                                        .contains(sortedList[
                                                                index]
                                                            ['destination'])))
                                                    .toList();

                                                if (data.length >= 1) {
                                                  var imageList = getImageList(
                                                      data[0]["images"]
                                                          .toString());
                                                  imageList.add(imageUrl);
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "placeImages/")
                                                      .doc(sortedList[index]
                                                          ["destination"])
                                                      .update({
                                                    "images": imageList
                                                  }).then((value) {
                                                    customShowAlertDialog(
                                                        context,
                                                        messsage:
                                                            "Image uploaded Successfully");
                                                  }).catchError((onError) {
                                                    customShowAlertDialog(
                                                        context,
                                                        messsage:
                                                            "Error $onError");
                                                  });
                                                } else {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "placeImages/")
                                                      .doc(sortedList[index]
                                                          ["destination"])
                                                      .set({
                                                    "images": [imageUrl],
                                                    "placeName":
                                                        sortedList[index]
                                                            ["destination"],
                                                  }).then((value) {
                                                    customShowAlertDialog(
                                                        context,
                                                        messsage:
                                                            "Image uploaded Successfully");
                                                  }).catchError((onError) {
                                                    customShowAlertDialog(
                                                        context,
                                                        messsage:
                                                            "Error in uploading $onError");
                                                  });
                                                  setState(() {
                                                    imageUploading = false;
                                                  });
                                                }
                                                // print("We Found element ${value.docs.contains(element)}")
                                                return null;
                                              }).catchError((onError) {
                                                print(onError);
                                              });
                                              // });
                                            });
                                            setState(() {
                                              imageUploading = false;
                                            });
                                          }).catchError((onError) {
                                            print(onError);
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          // color: Colors.green,
                                          color: Color(0xff3C8DAD),
                                        ),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  // color: Colors.green,
                                  color: Color(0xff3C8DAD),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("placeImages/")
                                        .get()
                                        .then((querySnapshot) {
                                      List data = querySnapshot.docs
                                          .toList()
                                          .where((element) => (element.id
                                              .contains(sortedList[index]
                                                  ['destination'])))
                                          .toList();

                                      if (data.length >= 1) {
                                        var imageList = getImageList(
                                            data[0]["images"].toString());

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            elevation: 44,
                                            title: Text(
                                              "Images",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: CarouselSlider(
                                              items: imageList
                                                  .map((item) => Container(
                                                        child: Center(
                                                            child:
                                                                Image.network(
                                                          item
                                                              .toString()
                                                              .trim(),
                                                          fit: BoxFit.cover,
                                                          // height: height,
                                                        )),
                                                      ))
                                                  .toList(),
                                              options: CarouselOptions(
                                                enlargeCenterPage: true,
                                              ),
                                            ),
                                            actions: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Close",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red[100],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                // onTap: ,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                              "Images",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                                "Sorry No Image Found for this Place "),
                                            actions: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // onTap: ,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      ;
                                    }).catchError((onError) {
                                      print(onError);
                                    });
                                  },
                                  child: Text(
                                    "View Images",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // bottomSheet: DraggableScrollableSheet(
      //   builder: (BuildContext context, ScrollController scrollController) {
      //     return Container(
      //       child: Text("HI"),
      //     );
      //   },
      // ),
      // ),
    );
  }
}
