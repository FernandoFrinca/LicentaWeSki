import 'package:flutter/material.dart';
import 'package:weski/Widget/groupCard.dart';

import '../Widget/friendCard.dart';

class friendsPage extends StatefulWidget {
  const friendsPage({super.key});

  @override
  State<friendsPage> createState() => _friendsPageState();
}

class _friendsPageState extends State<friendsPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardHeight = screenHeight * 0.21;
    double friendsHeight = screenHeight * 0.1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context, false),
        ),
        centerTitle: true,
        title: Text("Friends", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 12,
            ),
            child: IconButton(onPressed:(){

            }, icon: Icon(Icons.person_add_outlined, size: 36,)),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 16.0
                ),
                child: Text("Your groups:", style: TextStyle(fontSize: 32),),
              ),
              SizedBox(
                height: cardHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    groupCard(cardHeight: cardHeight,),
                    groupCard(cardHeight: cardHeight,),
                    groupCard(cardHeight: cardHeight,),
                    groupCard(cardHeight: cardHeight,),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 16.0
                ),
                child: Text("Your friends:", style: TextStyle(fontSize: 32),),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                    friendCard(cardHeight: friendsHeight,),
                  ],
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
                onPressed: ()  {

                },
                fillColor: Color(0xFF007EA7),
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
