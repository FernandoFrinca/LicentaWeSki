import 'dart:io';
import 'dart:math';

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
  final bool isForEdit;
  final int userId;
  final ValueNotifier<String?> profileImageNotifier;

  const customProfileAvatar({
    super.key,
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: screenDiagonal * 0.009, left: screenDiagonal * 0.017),
      child: Stack(
        children: [
          Container(
            width: screenDiagonal * 0.19,
            height: screenDiagonal * 0.19,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(theme.colorScheme.surface.value), const Color(0xFF007EA7)],
                stops: const [0.5, 0.5],
              ),
              boxShadow: const [
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
                  width: screenDiagonal * 0.04,
                  height: screenDiagonal * 0.04,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: screenDiagonal * 0.025,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}