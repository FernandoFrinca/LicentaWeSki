import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> addImageFireStore(File profilePicture) async {
  String image = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$image');
  await storageRef.putFile(profilePicture);
  String url = await storageRef.getDownloadURL();
  return url;
}