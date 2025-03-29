import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Pages/EditProfilePage.dart';
import 'package:weski/Widget/infoWidget.dart';
import 'package:weski/Widget/profileAvatar.dart';

import '../Api/Firestore.dart';
import '../Assets/Theme.dart';
import '../ConcretObjects/User.dart';
import '../Widget/customButton.dart';
import '../Widget/customDropDownInfo.dart';
import '../Widget/customTriangle.dart';
import '../Widget/editInfoWidget.dart';

class editProfilePage extends StatefulWidget {

  final User? curentUser;
  final ValueNotifier<String?> imageUpdateNotifie;
  editProfilePage({
    Key? key,
    required this.curentUser,
    required this.imageUpdateNotifie
  }) : super(key: key);

  @override
  State<editProfilePage> createState() => _editProfilePageState();
}

class _editProfilePageState extends State<editProfilePage> {

  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  String? selectedCategory;
  String? saveProfilePhotoUrl;
  int? gender;
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.curentUser!.category.isNotEmpty?widget.curentUser!.category:null;
    gender = widget.curentUser!.gender == 2
        ? null
        : widget.curentUser!.gender;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    final theme = Theme.of(context);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xFF007EA7),
        leading: IconButton(onPressed:(){
          Navigator.pop(context,false);
        }, icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: screenDiagonal * 0.035),),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: screenDiagonal * 0.03, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(0xFF007EA7),
      body: Stack(
        children: [
          Positioned(
              right: screenWidth * 0.045,
              bottom: screenHeight * 0.665,
              child: ClipPath(
                child: Container(
                  color: Color(theme.colorScheme.surface.value),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.0004,
              bottom: screenHeight * 0.682,
              child: ClipPath(
                child: Container(
                  color: Color(theme.colorScheme.surface.value),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.06,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.13,
              bottom: screenHeight * 0.645,
              child: ClipPath(
                child: Container(
                  color: Color(theme.colorScheme.surface.value),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.18,
              bottom: screenHeight * 0.625,
              child: ClipPath(
                child: Container(
                  color: Color(theme.colorScheme.surface.value),
                  width: screenWidth * 0.37,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.7,
              width: screenWidth,
              decoration:BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Color(theme.colorScheme.surface.value),
              ),
              child:SingleChildScrollView(
                child: Padding(
                  padding:EdgeInsets.only(
                    top: screenHeight * 0.07,
                    right: screenWidth * 0.09,
                    left: screenWidth * 0.09,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:EdgeInsets.only(
                              left: screenWidth * 0.03,
                            ),
                            child: Icon(
                              Icons.dark_mode_sharp,
                              size: screenWidth * 0.08,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(
                              left: screenWidth * 0.01,
                            ),
                            child: AutoSizeText(
                              "DarkMode",
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:EdgeInsets.only(
                              right: screenWidth * 0.03,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: theme.brightness == lightTheme.brightness? Colors.red : Colors.green,
                              ),
                              width: screenDiagonal * 0.022,
                              height: screenDiagonal * 0.022,
                            ),
                          )
                        ],
                      ),
                      editInfoWidget(
                        selectedData: widget.curentUser!.getUsername(),
                        selectedI: Icons.person,
                        selectediconColor: theme.colorScheme.onSurface.value,
                        selectedtextColor: theme.colorScheme.onSurface.value,
                        screenH: screenHeight,
                        screenW: screenWidth,
                        dataController: userController,
                        isNumeric: false,
                      ),
                      editInfoWidget(
                        selectedData: widget.curentUser!.getEmail(),
                        selectedI: Icons.mail_rounded,
                        selectediconColor: theme.colorScheme.onSurface.value,
                        selectedtextColor: theme.colorScheme.onSurface.value,
                        screenH: screenHeight,
                        screenW: screenWidth,
                        dataController: emailController,
                        isNumeric: false,
                      ),
                      editInfoWidget(
                        selectedData:(widget.curentUser!.getAge() == 0) ? 'Not Set' : widget.curentUser!.getAge().toString(),
                        selectedI: Icons.calendar_month_rounded,
                        selectediconColor: theme.colorScheme.onSurface.value,
                        selectedtextColor: theme.colorScheme.onSurface.value,
                        screenH: screenHeight,
                        screenW: screenWidth,
                        dataController: ageController,
                        isNumeric: true,
                      ),
                      customDropDownInfo<int>(
                        selectedValue:  gender == 2 ? null : gender,
                        onChanged: (int? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        icon: Icons.supervised_user_circle_rounded,
                        iconColor: theme.colorScheme.onSurface.value,
                        textColor: theme.colorScheme.onSurface.value,
                        screenW: screenWidth,
                        screenH: screenHeight,
                        hintText: "Select Gender",
                        items: const [
                          DropdownMenuItem(value: 0, child: Text("Male")),
                          DropdownMenuItem(value: 1, child: Text("Female")),
                        ],
                      ),
                      customDropDownInfo<String>(
                        selectedValue: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        icon: Icons.category,
                        iconColor: theme.colorScheme.onSurface.value,
                        textColor: theme.colorScheme.onSurface.value,
                        screenW: screenWidth,
                        screenH: screenHeight,
                        hintText: "Select Category",
                        items: const [
                          DropdownMenuItem(value: "Skier", child: Text("Skier")),
                          DropdownMenuItem(value: "Snowboarder", child: Text("Snowboarder")),
                        ],
                      ),

                      editInfoWidget(
                        selectedData: "new password",
                        selectedI: Icons.password_rounded,
                        selectediconColor: 0xFFF20000,
                        selectedtextColor: theme.colorScheme.onSurface.value,
                        screenH: screenHeight,
                        screenW: screenWidth,
                        dataController: passwordController,
                        isNumeric: false,
                      ),

                      editInfoWidget(
                        selectedData: "verify new password",
                        selectedI: Icons.password_rounded,
                        selectediconColor: 0xFFF20000,
                        selectedtextColor: theme.colorScheme.onSurface.value,
                        screenH: screenHeight,
                        screenW: screenWidth,
                        dataController: verifyPasswordController,
                        isNumeric: false,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Divider(color: Colors.grey.shade300, thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customButton(
                              data: "Save",
                              icon: Icons.save_outlined,
                              iconColor: 0xFF00C200,
                              textColor: theme.colorScheme.onSurface.value,
                              textSize: screenWidth * 0.045,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              paddingWidth: 0.03,
                              paddingHeight: 0.01,
                              onTap: () async {
                                if(passwordController.text.isNotEmpty && verifyPasswordController.text.isNotEmpty){
                                  await userApi.resetPassword(widget.curentUser!.id, passwordController.text, verifyPasswordController.text);
                                }
                                if (userController.text.isNotEmpty ||
                                    ageController.text.isNotEmpty ||
                                    emailController.text.isNotEmpty ||
                                    selectedCategory != null ||
                                    gender != null) {
                                  User updateUser = new User();
                                  updateUser.gender = gender;
                                  updateUser.age = int.tryParse(ageController.text);
                                  updateUser.category = selectedCategory ?? widget.curentUser!.getCategory();
                                  updateUser.email = emailController.text.isNotEmpty
                                      ? emailController.text
                                      : widget.curentUser!.getEmail();
                                  updateUser.username = userController.text.isNotEmpty
                                      ? userController.text
                                      : widget.curentUser!.getUsername();
                                  await userApi.updateUser(widget.curentUser!.id, updateUser);
                                }
                                if(widget.imageUpdateNotifie.value != null && widget.imageUpdateNotifie.value!.startsWith('file://')){
                                  File localImage = File(widget.imageUpdateNotifie.value!.replaceFirst('file://', ''));
                                  String uploadedUrl = await addImageFireStore(localImage);
                                  await userApi.updateProfilePicture(widget.curentUser!.id, uploadedUrl);
                                  widget.imageUpdateNotifie.value = uploadedUrl;
                                }

                                Navigator.pop(context,true);
                              },
                              iconSize: screenWidth * 0.08,
                              paddingText: screenWidth * 0.01
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customProfileAvatar(
                  isForEdit: true,
                  userId: widget.curentUser!.id,
                  profileImageNotifier: widget.imageUpdateNotifie
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.02),
                    child:  Text(
                      widget.curentUser!.getUsername().toUpperCase(),
                      style: TextStyle(fontSize: screenDiagonal * 0.028, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.02,
                    ),
                    child:  Text(
                      widget.curentUser!.getCategory(),
                      style: TextStyle(fontSize: screenDiagonal * 0.018, fontWeight: FontWeight.bold, color: Color(0xFFF0F0F0),),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
