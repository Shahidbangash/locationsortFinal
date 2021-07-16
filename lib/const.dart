import 'dart:io';

import 'package:flutter/material.dart';

var headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
  'Access-Control-Allow-Methods': '*',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': '*'
};

var selectedCity = {};

List getImageList(String imageList) {
  return imageList.substring(1, imageList.length - 1).split(",");
}

void customShowAlertDialog(BuildContext context,
    {String messsage = "this is response"}) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Response"),
    content: Text(messsage),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
