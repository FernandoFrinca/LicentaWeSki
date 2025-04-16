import 'dart:collection';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/ConcretObjects/Statistics.dart';
import 'package:weski/Widget/addFriends.dart';
import 'package:weski/Widget/createGroup.dart';
import 'package:weski/Widget/groupCard.dart';
import 'package:weski/Widget/shortcutCard.dart';

import '../Api/userApi.dart';
import '../ConcretObjects/Friend.dart';
import '../ConcretObjects/Group.dart';
import '../Widget/CustomSlider.dart';
import '../Widget/customTriangle.dart';
import '../Widget/friendCard.dart';
import '../Widget/friendStatisticCard.dart';


class groupPage extends StatefulWidget {

  final Group group;
  final int currentUser;

  const groupPage({Key? key, required this.group, required this.currentUser}) : super(key: key);


  @override
  State<groupPage> createState() => _groupPageState();
}

class _groupPageState extends State<groupPage> {

  late Group currentGroup;
  late int currentUser;
  late Set<Friend> groupMembers;
  ScrollController scrollController = new ScrollController();
  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    currentGroup = widget.group;
    currentUser = widget.currentUser;
    groupMembers = currentGroup.groupMmembers;
    for(var member in groupMembers){
      member.max_speed = 0;
      member.total_distance = 0;
    }
    fetchStatistics();

  }

  Future<void> fetchStatistics() async {
    List<Statistics> stats = await userApi.getGroupStatistics(currentGroup.id);
    groupMembers = await SplayTreeSet<Friend>((a, b) => a.id.compareTo(b.id),)..addAll(groupMembers);
    stats.sort((a, b) => a.user_id.compareTo(b.user_id));
    for(int member = 0; member < groupMembers.length; member++){
      groupMembers.elementAt(member).max_speed = stats[member].max_speed;
      groupMembers.elementAt(member).total_distance = stats[member].total_distance;
    }
    setState(() {
      groupMembers = SplayTreeSet<Friend>((a, b) =>
          b.max_speed.compareTo(a.max_speed),)
        ..addAll(groupMembers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int userCardColor = theme.colorScheme.secondary.withOpacity(0.3).value;
    int backgroundcolor = theme.colorScheme.surface.value;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    double friendsHeight = screenHeight * 0.1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(theme.colorScheme.primary.value,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white,size: screenDiagonal * 0.035),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text(currentGroup.name, style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Are you sure you want to leave this group?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            groupApi.removeUserFromGroup(currentGroup.id,currentUser);
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 100), () {
                              Navigator.pop(context, "remove");
                            });
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.exit_to_app_outlined,
                size: screenDiagonal * 0.035,
                color: Colors.white,
              ),
            ),
          ),
        ],

      ),
      backgroundColor: Color(0xFF007EA7),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.025,
            left: 0,
            right: 0,
            child: SizedBox(
              height: screenHeight * 0.225,
              child: CarouselSlider.builder(
                itemCount: groupMembers.length,
                itemBuilder: (context, index, realIndex) {
                  print("imaginea inainte sa fie triisa din group page ${groupMembers.elementAt(index).username}:");
                  print(groupMembers.elementAt(index).profile_picture);
                  return friendStatisticCard(
                    name: groupMembers.elementAt(index).username,
                    category: groupMembers.elementAt(index).category,
                    imagePath: groupMembers.elementAt(index).profile_picture,
                    fillColor: userCardColor,
                    total_distance: groupMembers.elementAt(index).total_distance,
                    max_speed: groupMembers.elementAt(index).max_speed,
                  );
                }, options: CarouselOptions(
                    autoPlay: true,
                    scrollDirection: Axis.horizontal,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 3000),
                    enlargeCenterPage: true,
                    viewportFraction: 0.4,
                  ),
              ),
            ),
          ),
          Positioned(
              right: screenWidth * 0.045,
              bottom: screenHeight * 0.565,
              child: ClipPath(
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.0004,
              bottom: screenHeight * 0.582,
              child: ClipPath(
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.06,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.13,
              bottom: screenHeight * 0.545,
              child: ClipPath(
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Positioned(
              right: screenWidth * 0.18,
              bottom: screenHeight * 0.525,
              child: ClipPath(
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.37,
                  height: screenHeight * 0.105,
                ),
                clipper: customTriangle(),
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.6,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Color(backgroundcolor),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    CustomSlider(
                      text1: "Shortcut",
                      text2: "Ranking",
                      sliderColor: theme.colorScheme.primary.value,
                      selectedTextColor: theme.colorScheme.onPrimary.value,
                      onToggle: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    selectedIndex == 0
                        ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            shortcutCard(
                                text1: "Break",
                                text2: "Send",
                                dataIcon: Icons.free_breakfast,
                                fillcolor: theme.colorScheme.primary.value,
                                chipcolor: backgroundcolor,
                                notificationId: 1,
                                sederId: currentUser,
                                groupId: currentGroup.id,
                            ),
                            shortcutCard(
                              text1: "Let's Ride!",
                              text2: "Send",
                              dataIcon: Icons.downhill_skiing,
                              fillcolor: theme.colorScheme.primary.value,
                              isleft: false,
                              chipcolor: backgroundcolor,
                              notificationId: 2,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            shortcutCard(
                              text1: "Broken Equipment",
                              text2: "Send",
                              dataIcon: Icons.settings,
                              fillcolor: theme.colorScheme.primary.withOpacity(0.75).value,
                              chipcolor: backgroundcolor,
                              notificationId: 1,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                            shortcutCard(
                              text1: "Let's Regroup!",
                              text2: "Send",
                              dataIcon: Icons.groups,
                              fillcolor: theme.colorScheme.primary.withOpacity(0.75).value,
                              isleft: false,
                              chipcolor: backgroundcolor,
                              notificationId: 1,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            shortcutCard(
                              text1: "I need help!",
                              text2: "Send",
                              dataIcon: Icons.warning,
                              fillcolor: theme.colorScheme.primary.withOpacity(0.55).value,
                              chipcolor: backgroundcolor,
                              notificationId: 1,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                            shortcutCard(
                              text1: "Home",
                              text2: "Send",
                              dataIcon: Icons.home,
                              fillcolor: theme.colorScheme.primary.withOpacity(0.55).value,
                              isleft: false,
                              chipcolor: backgroundcolor,
                              notificationId: 1,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                          ],
                        ),
                      ],
                    )
                        :  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 25, bottom: 10),
                            child: Text(
                              "Ranking by speed:",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: groupMembers.length,
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8.0),
                              itemBuilder: (context, index) {
                                return friendCard(
                                  cardHeight: friendsHeight,
                                  username: groupMembers.elementAt(index).username,
                                  category: groupMembers.elementAt(index).category,
                                  currentId: currentUser,
                                  friendId: groupMembers.elementAt(index).id,
                                  profilePhotoLink: groupMembers.elementAt(index).profile_picture,
                                  index: index,
                                  requests: [],
                                  isItRequest: false,
                                  isOnlyDisplay: true,
                                  onRemove: () => {},
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
