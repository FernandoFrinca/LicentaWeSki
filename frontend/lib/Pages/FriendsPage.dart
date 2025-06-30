import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Pages/GroupPage.dart';
import 'package:weski/Widget/addFriends.dart';
import 'package:weski/Widget/createGroup.dart';
import 'package:weski/Widget/groupCard.dart';

import '../ConcretObjects/Friend.dart';
import '../ConcretObjects/Group.dart';
import '../Widget/friendCard.dart';


class FriendsPage extends StatefulWidget {

  final int curentUserId;
  final List<Friend> friends;
  final List<Group> groups;

  const FriendsPage({Key? key, required this.curentUserId, required this.friends, required this.groups}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  late List<Group> groups;
  final TextEditingController _friendController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();

  @override
  void dispose() {
    _friendController.dispose();
    _groupController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    groups = List.from(widget.groups);
  }


  void removeFriendFromList(int index) {
    setState(() {
      widget.friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenDiagonal = sqrt(pow(screenWidth,2)+pow(screenHeight,2));
    double cardHeight = screenHeight * 0.21;

    double friendsHeight = screenHeight * 0.1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: screenDiagonal * 0.035),
          onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text("Friends", style: TextStyle(fontSize: screenDiagonal * 0.03, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth * 0.015,
            ),
            child: IconButton(onPressed:(){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return addFriends(friendController: _friendController, currentUserId: widget.curentUserId,);
                },
              );
            }, icon: Icon(Icons.person_add_outlined, size: screenDiagonal * 0.035,)),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenDiagonal * 0.016
                ),
                child: Text("Your groups:", style: TextStyle(fontSize: screenDiagonal * 0.032),),
              ),
              SizedBox(
                height: cardHeight,
                child:
                ListView.builder(
                  itemCount: groups.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    return groupCard(
                      //cardHeight: cardHeight,
                      groupName: groups[index].name,
                      groupPhoto: groups[index].group_photo,
                      onTap: () async {
                          final result = await Navigator.push(context,MaterialPageRoute(builder:(context) => groupPage(group: groups[index], currentUser: widget.curentUserId,)));
                          if(result == "remove"){
                            setState(() {
                              groups.removeAt(index);
                            });
                          }
                        },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenDiagonal * 0.016
                ),
                child: Text("Your friends:", style: TextStyle(fontSize: screenDiagonal * 0.032),),
              ),
              Expanded(
                child:
                ListView.builder(
                  itemCount: widget.friends.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    return friendCard(
                      cardHeight: friendsHeight,
                      username: widget.friends[index].username,
                      category: widget.friends[index].category,
                      currentId: widget.curentUserId,
                      friendId: widget.friends[index].id,
                      profilePhotoLink: widget.friends[index].profile_picture,
                      index: index,
                      requests: [],
                      isItRequest: false,
                      onRemove: () => removeFriendFromList(index),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: screenWidth * 0.01,
            bottom: screenHeight * 0.03,
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.015,),
              child: RawMaterialButton(
                onPressed: ()  async {
                  final newGroupId = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  createGroup(
                        groupController: _groupController,
                        currentUserId: widget.curentUserId,
                        friends: widget.friends,
                        cardHeigh: cardHeight,
                      );
                    },
                  );
                  if (newGroupId != null) {
                    Group? newGroup = await groupApi.fetchGroup(newGroupId);
                    setState(() {
                      groups.add(newGroup!);
                    });
                  }
                },
                fillColor: const Color(0xFF007EA7),
                shape: const CircleBorder(),
                elevation: 5,
                constraints: BoxConstraints(
                  minWidth: screenWidth * 0.13,
                  minHeight: screenWidth * 0.13,
                ),
                child: Icon(
                  Icons.group_add_outlined,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
