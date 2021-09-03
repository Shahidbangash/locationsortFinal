import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:locationsort/getLocation.dart';
import 'package:locationsort/sortedPage.dart';

var cityNames = [];
bool loading = true;

class LoadCsvDataScreen extends StatefulWidget {
  final String path;

  final List<dynamic> csvContent;

  LoadCsvDataScreen({Key key, this.path, this.csvContent});

  @override
  State<LoadCsvDataScreen> createState() => _LoadCsvDataScreenState();
}

class _LoadCsvDataScreenState extends State<LoadCsvDataScreen> {
  var cityList = [];
  var resultFromGoogle = [];

  // final String path;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("WidgetsBinding");
      getCurrentPosition().then((value) {
        getCurrentPlaceName(value);
      });
      // print(object)
      if (kIsWeb) {
        cityNames = [];
        for (var i = 1; i < this.widget.csvContent.length; i++) {
          cityNames.add(this.widget.csvContent[i][4].toString().trim() +
              " " +
              this.widget.csvContent[i][5].toString().trim());
          // print("CityName is $cityNames");
        }
        setState(() {});
      }
    });
  }

  // List<dynamic> csvContent;

  // _LoadCsvDataScreenState({this.path, this.csvContent});

  int current = 0;
  bool progress = false;
  List<List> csvFiles = [];

  dynamic fetchLocation(String source, String destinaiton) async {
    // var apiKey = "AIzaSyC92UARV7HJsL0iq2jMsue7JMQJeg2LBcE";
    // var apiKey = " AIzaSyBoYF-LSJz5rEcndQwVyVQoXK9awzTfdp0";
    var url = "https://getlocationgoogle.herokuapp.com/fetchLocation";

    print("Calling url is $url");

    await http.post(
      Uri.parse(url),
      body: {"source": source, "destination": destinaiton},
    ).then((response) {
      print("response is ${response.body}");
      resultFromGoogle.add(jsonDecode(response.body));
    }).catchError((onError) {
      print("Error while fetching reconds $onError");
    });

    // var responseData = response.body;

    // print("response datra is ${response.body}");
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
                          setState(() {
                            resultFromGoogle = [];
                            progress = true;
                          });

                          if (kIsWeb) {
                            for (var i = 2; i < cityNames.length - 1; i++) {
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
                          } else {
                            for (var i = 2; i < cityNames.length; i++) {
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
              kIsWeb
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: this.widget.csvContent.length - 1,
                          itemBuilder: (context, i) {
                            // print("Item cpunt is $i");
                            // print(
                            // "And item is ${this.widget.csvContent[i][0]}");

                            // children: this.widget.csvContent.map((item) {
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          // item.toString()
                                          this
                                              .widget
                                              .csvContent[i][0]
                                              .toString()
                                          // item[0].toString().trim(),
                                          ),
                                      SizedBox(
                                        width: 180,
                                        child: Center(
                                          child: Text(
                                            // item.toString()
                                            this
                                                .widget
                                                .csvContent[i][4]
                                                .toString(),
                                            // item[4].toString().trim(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        this.widget.csvContent[i][5].toString(),
                                        // item.toString()
                                        // item[5].toString().trim(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // ),
                            );
                          }
                          // }).toList()
                          // return ;
                          ),
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
                  kIsWeb
                      ? "${current} of ${this.widget.csvContent.length} requests done"
                      : "${current} of ${cityNames.length} requests done",
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
      String path = file.path;

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
