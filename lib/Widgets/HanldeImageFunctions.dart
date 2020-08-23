import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

kSaveImage(String url, String id, String label) async {
  String name = "${id}_$label.jpg";
  var response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: name);
}

uploadImage(File imgFile, String postId, String label) async {
  StorageUploadTask uploadTask = FirebaseStorage.instance
      .ref()
      .child("${postId}_$label.jpg")
      .putFile(imgFile);
  StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
  return await storageSnap.ref.getDownloadURL();
}

pickSaveImage(context, File file, UserProvider provider) async {
  var uid = Uuid().v4();

  StorageReference ref = FirebaseStorage.instance.ref().child(uid + ".jpg");
  StorageUploadTask uploadTask = ref.putFile(file);
  final url = await (await uploadTask.onComplete).ref.getDownloadURL();
  await Firestore.instance
      .collection("files")
      .document(provider.user.uid)
      .collection("")
      .document(uid)
      .setData({
    'url': url,
    'uid': uid,
  });

  file = null;
}

handleTakePhoto(context, UserProvider provider) async {
  Navigator.pop(context);
  File file = await ImagePicker.pickImage(
      source: ImageSource.camera, maxWidth: 960, maxHeight: 675);
  if (file == null) return;
  file = await cropImage(file);
  return file;
}

cropImage(File imageFile) async {
  return await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Edit Image',
        toolbarColor: Colors.redAccent,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioLockEnabled: false,
      ));
}

handleChooseFromGallary(context, UserProvider provider) async {
  Navigator.pop(context);
  File file = await ImagePicker.pickImage(
      source: ImageSource.gallery, maxWidth: 960, maxHeight: 675);
  if (file == null) return;
  file = await cropImage(file);
  return file;
}
