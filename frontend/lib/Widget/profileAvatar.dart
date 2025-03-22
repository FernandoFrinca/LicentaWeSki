import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Widget/customWheaterTimerDisplay.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Api/Firestore.dart';
import '../Pages/ProfilePage.dart';

class customProfileAvatar extends StatefulWidget{
  final double screenHeight;
  final double screenWidth;
  final bool isForEdit;
  final int userId;
  final ValueNotifier<String?> profileImageNotifier;

  const customProfileAvatar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
    required this.profileImageNotifier,
    this.isForEdit = false,
  });

  @override
  State<StatefulWidget> createState() => _customProfileAvatar();
}

class _customProfileAvatar extends State<customProfileAvatar> {
  File? profileImage;
  final ImagePicker imagePicker = ImagePicker();
  String? profileImageUrl;

  Future<void> getProfilePicture() async {
    final url = await userApi.fetchProfilePicture(widget.userId);
    setState(() {
      profileImageUrl = url;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInitialProfileImage();
  }

  void fetchInitialProfileImage() async {
    final url = await userApi.fetchProfilePicture(widget.userId);
    if(url != null && url.isNotEmpty && url != "empty"){
      widget.profileImageNotifier.value = url;
    } else {
      widget.profileImageNotifier.value = "empty";
    }
  }

  Future<void> selectImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
        widget.profileImageNotifier.value = 'file://${pickedFile.path}';
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenW = widget.screenWidth;
    return Padding(
      padding: EdgeInsets.only(top: 10.0, left: 18),
      child: Stack(
        children: [
          Container(
            width: screenW * 0.46,
            height: screenW * 0.46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFF007EA7)],
                stops: [0.5, 0.5],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: ValueListenableBuilder<String?>(
                  valueListenable: widget.profileImageNotifier,
                  builder: (context, url, _) {
                      if (url != null && url.startsWith('file://')) {
                        return Image.file(File(url.replaceFirst('file://', '')), fit: BoxFit.cover);
                      } else if (url != null && url != "empty" && url.isNotEmpty) {
                        return Image.network(url, fit: BoxFit.cover);
                      } else {
                        return Image.asset('assets/goggles_lightmode.png', fit: BoxFit.cover);
                      }
                    },
                  ),
                ),
              ),
            ),
          if (widget.isForEdit)
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: selectImage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}