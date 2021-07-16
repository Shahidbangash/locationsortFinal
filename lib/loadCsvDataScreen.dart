import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationsort/const.dart';
import 'package:http/http.dart' as http;
import 'package:locationsort/sortedPage.dart';

// import 'global_data.dart';

var cityNames = [];
bool loading = true;

class LoadCsvDataScreen extends StatefulWidget {
  final String path;

  List<dynamic> csvContent;

  LoadCsvDataScreen({Key key, this.path, this.csvContent});

  @override
  State<LoadCsvDataScreen> createState() =>
      _LoadCsvDataScreenState(csvContent: csvContent);
}

class _LoadCsvDataScreenState extends State<LoadCsvDataScreen> {
  var cityList = [];
  var resultFromGoogle = [];

  final String path;

  List<dynamic> csvContent;

  _LoadCsvDataScreenState({this.path, this.csvContent});

  sortList() async {}

  // Future<dynamic> getLattitude(String address) async {
  //   if (kIsWeb) {
  //     final httpClient = HttpClient();
  //     final request = await httpClient.getUrl(Uri.parse('http://google.com'));
  //     final response = await request.close();
  //     print(response.toString());
  //   } else {
  //     final response = await http.get(
  //         Uri.parse(
  //             "https://maps.googleapis.com/maps/api/geocode/json?address=${address},+CA&key=AIzaSyC92UARV7HJsL0iq2jMsue7JMQJeg2LBcE"),
  //         headers: headers);
  //     print("Response is ${response}");

  //     if (response.statusCode == 200) {
  //       // If the server did return a 200 OK response,
  //       // then parse the JSON.
  //       // print(jsonDecode(response.body));

  //       var responseBody = jsonDecode(response.body);

  //       print("Response body is ");
  //       print(responseBody["results"][0]["geometry"]["location"]);

  //       var latlong = responseBody["results"][0]["geometry"]["location"];
  //       return [latlong["lat"], latlong["lng"]];
  //     }
  //   }
  // }
  int current = 0;
  bool progress = false;
  List<List> csvFiles = [];

  dynamic fetchLocation(String source, String destinaiton) async {
    // var apiKey = "AIzaSyC92UARV7HJsL0iq2jMsue7JMQJeg2LBcE";
    // var apiKey = " AIzaSyBoYF-LSJz5rEcndQwVyVQoXK9awzTfdp0";
    var url = "https://getlocationgoogle.herokuapp.com/fetchLocation";

    print("Calling url is $url");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {"source": source, "destination": destinaiton},
      );
      print("response code is ${response.headers}");

      var responseData = response.body;

      print("response datra is ${response.body}");

      resultFromGoogle.add(jsonDecode(responseData));

      return responseData;

      // return jsonDecode(response.body);
    } catch (error) {
      print("Error $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: progress
                    ? CircularProgressIndicator()
                    : InkWell(
                        child: Text("Get Distance"),
                        onTap: () async {
                          setState(() {});
                          print(cityNames.isEmpty);
                          setState(() {
                            resultFromGoogle = [];
                            progress = true;
                          });

                          for (var i = 2; i < csvContent.length; i++) {
                            // for (var i = 2; i < 6; i++) {
                            // print("I is ${i}");
                            // print("total cities are ${cityNames.length}");
                            // print("City Name is ${cityNames[i]}");
                            // print("Current is $current");

                            setState(() {
                              current = i;
                            });

                            await fetchLocation(cityNames[1], cityNames[i]);
                          }

                          print("result from google $resultFromGoogle");

                          resultFromGoogle.sort((a, b) {
                            // resultFromGoogle.
                            // int num1 = int.parse(a["distance"]);
                            // int num2 = int.parse(b["distance"]);

                            return (a["distance"]).compareTo(b["distance"]);
                          });

                          // print("result from google after $resultFromGoogle");

                          setState(() {
                            progress = false;
                            loading = false;
                          });
                        },
                      ),
              ),
            ),
          ],
          title: const Text("CSV DATA"),
        ),
        body: Container(
          color: const Color(0xFFf8f9fd),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Data from CSV File",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const SizedBox(
              //         width: 44,
              //         child: Center(
              //           child: Text(
              //             "Page",
              //             style: TextStyle(
              //               fontSize: 16,
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 120,
              //         child: Text(
              //           "Adress",
              //           style: TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 60,
              //         child: Text(
              //           "City",
              //           style: TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              kIsWeb
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: csvContent.length,
                          itemBuilder: (context, i) {
                            cityNames.add(csvContent[i][4].toString().trim() +
                                " " +
                                csvContent[i][5].toString().trim());
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                elevation: 6,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 14,
                                    bottom: 14,
                                    left: 5,
                                    right: 5,
                                  ),
                                  decoration: const BoxDecoration(
                                      // border: Border.all(
                                      //   width: 1,
                                      // ),
                                      ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        csvContent[i][0].toString().trim(),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Center(
                                          child: Text(
                                            csvContent[i][4].toString().trim(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        csvContent[i][5].toString().trim(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : FutureBuilder(
                      future: kIsWeb ? csvFiles : loadingCsvData(widget.path),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        // ignore: avoid_print
                        // print(snapshot.data.toString());
                        if (snapshot.hasData) {
                          cityNames = [];
                        }
                        if (kIsWeb) {
                          print("Csv file ${csvFiles.length} is");
                        }
                        return snapshot.hasData
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: snapshot.data.map(
                                    (data) {
                                      // setState(() {
                                      cityNames.add(data[4].toString().trim() +
                                          " , " +
                                          data[5].toString().trim());
                                      // });

                                      print(
                                          "Snapshot data length is ${snapshot.data.length}");

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Card(
                                          elevation: 6,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: 14,
                                              bottom: 14,
                                              left: 5,
                                              right: 5,
                                            ),
                                            decoration: const BoxDecoration(
                                                // border: Border.all(
                                                //   width: 1,
                                                // ),
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  data[0].toString().trim(),
                                                ),
                                                SizedBox(
                                                  width: 180,
                                                  child: Center(
                                                    child: Text(
                                                      data[4].toString().trim(),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data[5].toString().trim(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
            ],
          ),
        ),
        floatingActionButton: loading == true
            ? Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: const Color(0xFF1d3557),
                    borderRadius: const BorderRadius.all(Radius.circular(44))),
                child: Text(
                  "${current} of ${csvContent.length} requests done",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : InkWell(
                enableFeedback: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SortedListPage(
                        sortedList: resultFromGoogle,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1d3557),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(44))),
                  child: const Text(
                    "Show Sorted Location",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      String path = file.path as String;

      final input = File(path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      print(fields);
    }
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(),
        )
        .toList();
  }
}
