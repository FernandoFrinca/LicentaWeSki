import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Widget/CustomTextField.dart';

import '../Api/Firestore.dart';
import '../ConcretObjects/Friend.dart';
import 'friendCard.dart';
import 'groupAddList.dart';

class createGroup extends StatefulWidget {
  final TextEditingController groupController;
  final List<Friend> friends;
  final int currentUserId;

  final double cardHeigh;

  const createGroup({
    Key? key,
    required this.groupController,
    required this.currentUserId,
    required this.friends,
    required this.cardHeigh,
  }) : super(key: key);

  @override
  State<createGroup> createState() => _createGroupState();
}

class _createGroupState extends State<createGroup> {

  String? errorMessage;
  Set<int> createGroupFriendsList = new HashSet();
  final ImagePicker imagePicker = ImagePicker();
  late String selectedImagePath = "empty";

  Future<void> selectImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        selectedImagePath = 'file://${pickedFile.path}';
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void dispose() {
    widget.groupController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    return Dialog(
      child: Container(
        height: screenHeight * 0.75,
        width: screenWidth * 0.9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Create Group",
                style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 320,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 8,
                  right: 8
                ),
                child: CustomTextField(
                  label: "Group Name",
                  controller: widget.groupController,
                  icon: Icons.person_2_outlined,
                  borderColor: theme.colorScheme.onPrimary.value,
                  fillColor: theme.colorScheme.secondary.value,
                  iconColor: theme.colorScheme.primary.value,
                  texColor: theme.colorScheme.onSecondary.value,
                  borderRadius: 18,
                  errorState: false,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.friends.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return groupAddList(
                    username: widget.friends[index].username,
                    category: widget.friends[index].category,
                    currentId: widget.currentUserId,
                    friendId: widget.friends[index].id,
                    index: index,
                    usersIds: createGroupFriendsList,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () async {
                  await selectImage();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 8),
                    const Text(
                      "Set group photo",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () async {
                    if(widget.groupController.text.isNotEmpty){
                      int newGroup = await groupApi.createGroup(widget.groupController.text, widget.currentUserId);
                      createGroupFriendsList.add(widget.currentUserId);
                      await groupApi.addUsersToGroup(newGroup,createGroupFriendsList);
                      if(selectedImagePath.isNotEmpty && selectedImagePath != "empty"){
                        if(selectedImagePath.startsWith('file://')){
                          File localImage = File(selectedImagePath.replaceFirst('file://', ''));
                          String uploadedUrl = await addImageFireStore(localImage);
                          await groupApi.updateGropuPicture(newGroup,uploadedUrl);
                        }
                      }
                      Navigator.pop(context, newGroup);
                    }
                  },
                child: const Text(
                  "Create Group",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}