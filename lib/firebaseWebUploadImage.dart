// import 'dart:html' as html;
// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker_web/image_picker_web.dart';
// import 'package:mime_type/mime_type.dart';
// import 'package:path/path.dart' as Path;

// import 'package:flutter/material.dart';
// import "package:firebase/firebase.dart" as fb;
import "package:firebase/firebase.dart" as fb;

import 'const.dart';

// html.File _cloudFile;
// var _fileBytes;
// Image _imageWidget;

Future<void> startFilePicker(
  context, {
  var obj,
}) async {
  // var mediaData = await ImagePickerWeb.getImageInfo;
  var mediaFile = await ImagePickerWeb.getImage(
    outputType: ImageType.file,
  );
  // String mimeType = mime(Path.basename(mediaData.fileName));
  // html.File mediaFile =
  //     new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

  if (mediaFile != null) {
    fb.StorageReference storageRef =
        fb.storage().ref('placeImages/${obj['destination']}/${mediaFile}');

    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(mediaFile).future;

    Uri imageUri =
        await uploadTaskSnapshot.ref.getDownloadURL().then((imageUrl) {
      // print("URL is $value");

      // ..................................//
      // FireStore Part starts here

      FirebaseFirestore.instance
          .collection("placeImages/")
          .get()
          .then((querySnapshot) {
        List data = querySnapshot.docs
            .toList()
            .where((element) => (element.id.contains(obj['destination'])))
            .toList();

        // Images already there so update it
        if (data.length >= 1) {
          var imageList = getImageList(data[0]["images"].toString());
          imageList.add(imageUrl.toString());
          FirebaseFirestore.instance
              .collection("placeImages/")
              .doc(obj["destination"])
              .update({"images": imageList}).then((value) {
            customShowAlertDialog(context,
                messsage: "Image uploaded Successfully");
          }).catchError((onError) {
            print("Error while updating image $onError");
            customShowAlertDialog(context, messsage: "Error $onError");
          });
        } else {
          FirebaseFirestore.instance
              .collection("placeImages/")
              .doc(obj["destination"])
              .set({
            "images": [imageUrl.toString()],
            "placeName": obj["destination"],
          }).then((value) {
            customShowAlertDialog(context,
                messsage: "Image uploaded Successfully");
          }).catchError((onError) {
            print("Error in uploading new records $onError");
            customShowAlertDialog(context,
                messsage: "Error in uploading $onError");
          });
        }
        // print("We Found element ${value.docs.contains(element)}")
        return null;
      }).catchError((onError) {
        print(onError);
      });

      // FireStore part ends here
      // .................................//
      return imageUrl;
    });

    return imageUri;
  }
}
