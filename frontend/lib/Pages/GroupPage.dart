import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/ConcretObjects/Friend.dart';
import 'package:weski/ConcretObjects/Group.dart';
import 'package:weski/ConcretObjects/Statistics.dart';
import 'package:weski/Widget/CustomSlider.dart';
import 'package:weski/Widget/customTriangle.dart';
import 'package:weski/Widget/friendCard.dart';
import 'package:weski/Widget/friendStatisticCard.dart';
import 'package:weski/Widget/shortcutCard.dart';

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
  late List<Friend> groupMembers;
  ScrollController scrollController = ScrollController();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    currentGroup = widget.group;
    currentUser = widget.currentUser;
    groupMembers = currentGroup.groupMmembers.toList();

    for (var member in groupMembers) {
      member.max_speed = 0;
      member.total_distance = 0;
    }

    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      List<Statistics> stats = await userApi.getGroupStatistics(currentGroup.id);

      for (var stat in stats) {
        final index = groupMembers.indexWhere((f) => f.id == stat.user_id);
        if (index != -1) {
          groupMembers[index].max_speed = stat.max_speed;
          groupMembers[index].total_distance = stat.total_distance;
        }
      }

      groupMembers.sort((a, b) => b.max_speed.compareTo(a.max_speed));

      setState(() {});
    } catch (e) {
      print("Eroare la fetchStatistics: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int userCardColor = theme.colorScheme.secondary.withOpacity(0.3).value;
    int backgroundcolor = theme.colorScheme.surface.value;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2));
    double friendsHeight = screenHeight * 0.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(theme.colorScheme.primary.value),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: screenDiagonal * 0.035),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text(
          currentGroup.name,
          style: TextStyle(
            fontSize: screenDiagonal * 0.03,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                            groupApi.removeUserFromGroup(currentGroup.id, currentUser);
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 100), () {
                              Navigator.pop(context, "remove");
                            });
                          },
                          child: Text("Yes", style: TextStyle(color: Colors.red)),
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
                  return friendStatisticCard(
                    name: groupMembers[index].username,
                    category: groupMembers[index].category,
                    imagePath: groupMembers[index].profile_picture,
                    fillColor: userCardColor,
                    total_distance: groupMembers[index].total_distance,
                    max_speed: groupMembers[index].max_speed,
                  );
                },
                options: CarouselOptions(
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

          ...[
            Positioned(
              right: screenWidth * 0.045,
              bottom: screenHeight * 0.565,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
              ),
            ),
            Positioned(
              right: screenWidth * 0.0004,
              bottom: screenHeight * 0.582,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.06,
                ),
              ),
            ),
            Positioned(
              right: screenWidth * 0.13,
              bottom: screenHeight * 0.545,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.105,
                ),
              ),
            ),
            Positioned(
              right: screenWidth * 0.18,
              bottom: screenHeight * 0.525,
              child: ClipPath(
                clipper: customTriangle(),
                child: Container(
                  color: Color(backgroundcolor),
                  width: screenWidth * 0.37,
                  height: screenHeight * 0.105,
                ),
              ),
            ),
          ],

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
                              notificationId: 3,
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
                              notificationId: 4,
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
                              notificationId: 5,
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
                              notificationId: 6,
                              sederId: currentUser,
                              groupId: currentGroup.id,
                            ),
                          ],
                        ),
                      ],
                    )
                        : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 25, bottom: 10),
                            child: Text("Ranking by speed:", style: TextStyle(fontSize: 24)),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: groupMembers.length,
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8.0),
                              itemBuilder: (context, index) {
                                return friendCard(
                                  cardHeight: friendsHeight,
                                  username: groupMembers[index].username,
                                  category: groupMembers[index].category,
                                  currentId: currentUser,
                                  friendId: groupMembers[index].id,
                                  profilePhotoLink: groupMembers[index].profile_picture,
                                  index: index,
                                  requests: [],
                                  isItRequest: false,
                                  isOnlyDisplay: true,
                                  onRemove: () {},
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
          ),
        ],
      ),
    );
  }
}
