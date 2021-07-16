import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:csv_reader/csv_reader.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locationsort/googleMap.dart';
import 'package:locationsort/loadCsvDataScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
// import 'dart:html' as htmlfile;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Sorter',
      theme: ThemeData(
        primaryColor: const Color(0xFF1d3557),
        //  Color(oxFF457b9d)
        // primarySwatch: Colors.black,
      ),
      // home: MapPage(),
      home: MyHomePage(
        title: 'Locatin Sorter',
        //   // title: title,
        //   // key: null,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List csvList;
  List csvFileContentList = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  List<List> finalCsvContent = [];
  List CsvModuleList = [];

  PlatformFile selectedFile;
  Future selectCSVFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);

    if (result != null) {
      selectedFile = result.files.first;
      selectParseCSV();
      return;
    } else {
      selectedFile = null;
    }
  }

  // Select and Parse the CSV File
  void selectParseCSV() async {
    try {
      String s = new String.fromCharCodes(selectedFile.bytes);
      // Get the UTF8 decode as a Uint8List
      var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
      // split the Uint8List by newline characters to get the csv file rows
      csvFileContentList = utf8.decode(outputAsUint8List).split('\n');
      // print('Selected CSV File contents: ');
      csvFileContentList.forEach((element) {
        List currentRow = [];
        element.toString().split(",").forEach((items) {
          currentRow.add(items.trim());
        });

        setState(() {
          finalCsvContent.add(currentRow);
        });
      });

      // MaterialPageRoute(
      //   builder: (_) {
      //     return LoadCsvDataScreen(csvContent: finalCsvContent);
      //   },
      // );

// check if CSV file has any content - content length > 0?
      if (csvFileContentList.length == 0 || csvFileContentList[1].length == 0) {
        // CSV file does not have content
        print('CSV file has no content');
        // return 'Error: The CSV file has no content.';
      }
    } catch (e) {
      print(e.toString());

      // return 'Error: ' + e.toString();
    }

    // CsvModuleList.forEach((data) {
    //   print(data.toList());
    //   print(data.toJson());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedf6f9),
      appBar: AppBar(
        elevation: 8,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Note: You must enter have data in CSV like this",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(image: AssetImage("assets/images/demoPicture.PNG")),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  "In above Image, Row 2 address should be user current address ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1d3557),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    spreadRadius: 2,
                    // Col
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  loadCsvFromStorage();
                },
                // color: Colors.cyanAccent,
                child: const Text(
                  "Load CSV from phone storage",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadCsvFromStorage() async {
    if (kIsWeb) {
      await selectCSVFile();

      print("FInal csv length is ${finalCsvContent.length}");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadCsvDataScreen(
            csvContent: finalCsvContent,
          ),
        ),
      );

      // print("I am here");
    } else {
      // NOT running on the web! You can check for additional platforms here.

      try {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['csv'],
          type: FileType.custom,
        );

        String path = result.files.first.path as String;
        print("path is $path");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return LoadCsvDataScreen(path: path);
            },
          ),
        );
      } catch (ex) {
        print("EXception occured ar $ex");
      }
    }
  }
}

// Drag start here

class APP extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<APP> {
  Color caughtColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          DragBox(Offset(0.0, 0.0), 'Box One', Colors.blueAccent),
          DragBox(Offset(150.0, 0.0), 'Box Two', Colors.orange),
          DragBox(Offset(300.0, 0.0), 'Box Three', Colors.lightGreen),
          Positioned(
            left: 125.0,
            bottom: 0.0,
            child: DragTarget(
              onAccept: (Color color) {
                caughtColor = color;
              },
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: accepted.isEmpty
                        ? caughtColor
                        : Colors.deepPurple.shade200,
                  ),
                  child: Center(
                    child: Text("Drag Here!",
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  DragBox(this.initPos, this.label, this.itemColor);

  @override
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Draggable(
          data: widget.itemColor,
          child: Container(
            width: 100.0,
            height: 100.0,
            color: widget.itemColor,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              position = offset;
            });
          },
          feedback: Container(
            width: 120.0,
            height: 120.0,
            color: widget.itemColor.withOpacity(0.5),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ));
  }
}
// Drag ends here
