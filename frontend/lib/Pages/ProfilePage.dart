import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weski/Pages/EditProfilePage.dart';
import 'package:weski/Widget/infoWidget.dart';
import 'package:weski/Widget/profileAvatar.dart';

import '../Api/userApi.dart';
import '../Assets/Theme.dart';
import '../ConcretObjects/User.dart';
import '../Widget/customButton.dart';
import '../Widget/customTriangle.dart';
import 'LoginPage.dart';
import 'NotificationPage.dart';

class ProfilePage extends StatefulWidget {

  final User? curentUser;
  ProfilePage({Key? key, required this.curentUser}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ValueNotifier<String?> profileImageNotifier = ValueNotifier("");
  @override
  void initState() {
    super.initState();
    fetchInitialProfilePicture();
  }

  void fetchInitialProfilePicture() async {
    final url = await userApi.fetchProfilePicture(widget.curentUser!.id);
    if (url != null && url.isNotEmpty) {
      profileImageNotifier.value = url;
    }
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
          "Profile",
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
              clipper: customTriangle(),
              child: Container(
                color: Color(theme.colorScheme.surface.value),
                width: screenWidth * 0.35,
                height: screenHeight * 0.105,
              ),
            )
          ),
          Positioned(
            right: screenWidth * 0.0004,
            bottom: screenHeight * 0.682,
            child: ClipPath(
              clipper: customTriangle(),
              child: Container(
                color: Color(theme.colorScheme.surface.value),
                width: screenWidth * 0.2,
                height: screenHeight * 0.06,
              ),
            )
          ),
          Positioned(
            right: screenWidth * 0.13,
            bottom: screenHeight * 0.645,
            child: ClipPath(
              clipper: customTriangle(),
              child: Container(
                color: Color(theme.colorScheme.surface.value),
                width: screenWidth * 0.35,
                height: screenHeight * 0.105,
              ),
            )
          ),
          Positioned(
            right: screenWidth * 0.18,
            bottom: screenHeight * 0.625,
            child: ClipPath(
              clipper: customTriangle(),
              child: Container(
                color: Color(theme.colorScheme.surface.value),
                width: screenWidth * 0.37,
                height: screenHeight * 0.105,
              ),
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
              child:Padding(
                padding:EdgeInsets.only(
                  top: screenHeight * 0.07,
                  right: screenWidth * 0.09,
                  left: screenWidth * 0.09,
                ),
                child: Column(
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
                    Divider(color: Colors.grey.shade300, thickness: 1.0),
                    infoWidget(
                      selectedData: widget.curentUser!.getUsername(),
                      selectedI: Icons.person,
                      selectediconColor: theme.colorScheme.onSurface.value,
                      selectedtextColor: theme.colorScheme.onSurface.value,
                      screenH: screenHeight,
                      screenW: screenWidth,
                    ),
                    infoWidget(
                      selectedData: widget.curentUser!.getEmail(),
                      selectedI: Icons.mail_rounded,
                      selectediconColor: theme.colorScheme.onSurface.value,
                      selectedtextColor: theme.colorScheme.onSurface.value,
                      screenH: screenHeight,
                      screenW: screenWidth,
                    ),
                    infoWidget(
                      selectedData:(widget.curentUser!.getAge() == null) ? 'Not Set' : widget.curentUser!.getAge().toString(),
                      selectedI: Icons.calendar_month_rounded,
                      selectediconColor: theme.colorScheme.onSurface.value,
                      selectedtextColor: theme.colorScheme.onSurface.value,
                      screenH: screenHeight,
                      screenW: screenWidth,
                    ),
                    infoWidget(
                      selectedData: (widget.curentUser!.getGender() == 2)?'Not Set':widget.curentUser!.getGender().toString(),
                      selectedI: Icons.supervised_user_circle_rounded,
                      selectediconColor: theme.colorScheme.onSurface.value,
                      selectedtextColor: theme.colorScheme.onSurface.value,
                      screenH: screenHeight,
                      screenW: screenWidth,
                    ),
                    infoWidget(
                      selectedData: widget.curentUser!.getCategory(),
                      selectedI: Icons.category_rounded,
                      selectediconColor: theme.colorScheme.onSurface.value,
                      selectedtextColor: theme.colorScheme.onSurface.value,
                      screenH: screenHeight,
                      screenW: screenWidth,
                    ),
                    Divider(color: Colors.grey.shade300, thickness: 1.0),
                    customButton(
                        data: "Edit Profile",
                        icon: Icons.mode_edit_rounded,
                        iconColor: 0xFF1200A3,
                        textColor: theme.colorScheme.onSurface.value,
                        textSize: screenWidth * 0.045,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        paddingWidth: 0.03,
                        paddingHeight: 0.01,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editProfilePage(curentUser: widget.curentUser, imageUpdateNotifie:profileImageNotifier),
                            ),
                          );

                          if (result == true) {
                            setState(() {});
                          }
                        },
                        iconSize: screenWidth * 0.08,
                        paddingText: screenWidth * 0.01
                    ),
                    customButton(
                        data: "Notifications",
                        icon: Icons.notifications_rounded,
                        iconColor: 0xFFFFCE08,
                        textColor: theme.colorScheme.onSurface.value,
                        textSize: screenWidth * 0.045,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        paddingWidth: 0.03,
                        paddingHeight: 0.01,
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(curentUserId:widget.curentUser!.id,),
                            ),
                          );
                        },
                        iconSize: screenWidth * 0.08,
                        paddingText: screenWidth * 0.01
                    ),
                    Spacer(),
                    Divider(color: Colors.grey.shade300, thickness: 1.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customButton(
                            data: "Logout",
                            icon: Icons.logout,
                            iconColor: 0xFFF20000,
                            textColor: theme.colorScheme.onSurface.value,
                            textSize: screenWidth * 0.045,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            paddingWidth: 0.03,
                            paddingHeight: 0.01,
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Container(
                                      width: screenWidth * 0.2,
                                      height: screenHeight *0.1,
                                      decoration: BoxDecoration(
                                        color: Color(theme.colorScheme.surface.value),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Are you sure?", style: TextStyle(fontSize: screenDiagonal * 0.025),),
                                          customButton(
                                            data: "Logout",
                                            icon: Icons.logout,
                                            iconColor: 0xFFF20000,
                                            textColor: theme.colorScheme.onSurface.value,
                                            textSize: screenWidth * 0.04,
                                            screenWidth: screenWidth,
                                            screenHeight: screenHeight,
                                            paddingWidth: 0.13,
                                            paddingHeight: 0.01,
                                            onTap: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => LoginPage()),
                                                    (Route<dynamic> route) => false,
                                              );
                                              },
                                            iconSize: screenWidth * 0.08,
                                            paddingText: screenWidth * 0.01,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customProfileAvatar(userId: widget.curentUser!.id, profileImageNotifier: profileImageNotifier),
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
