import 'package:flutter/material.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/ConcretObjects/Friend.dart';

class friendCard extends StatefulWidget {
  final double cardHeight;
  final String username;
  final String category;
  final bool isItRequest;
  final int friendId;
  final int currentId;
  final List<Friend> requests;
  final int index;
  final String profilePhotoLink;
  final VoidCallback onRemove;
  final isOnlyDisplay ;

  const friendCard({
    super.key,
    required this.cardHeight,
    required this.username,
    required this.category,
    required this.isItRequest,
    required this.friendId,
    required this.currentId,
    required this.requests,
    required this.profilePhotoLink,
    required this.index,
    required this.onRemove,
     this.isOnlyDisplay = false,
  });

  @override
  State<friendCard> createState() => _friendCardState();
}

class _friendCardState extends State<friendCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Container(
        width: screenWidth * 0.8,
        height: widget.cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF8F8F8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: Container(
                width: widget.cardHeight * 0.8,
                height: widget.cardHeight * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.profilePhotoLink == "empty" || !widget.profilePhotoLink.isNotEmpty ?
                  Image.asset(
                    "assets/ski.jpeg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ) :
                  Image.network(
                    widget.profilePhotoLink,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child: Text(
                      widget.username,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
                    child: Text(
                      widget.category,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            widget.isOnlyDisplay == true? SizedBox() : (
              widget.isItRequest
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      userApi.respondeRequest(
                          widget.currentId, widget.friendId, false);
                      widget.onRemove();
                    },
                    icon: const Icon(
                        Icons.close_outlined, color: Colors.redAccent),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: () {
                      userApi.respondeRequest(
                          widget.currentId, widget.friendId, true);
                      widget.onRemove();
                    },
                    icon: const Icon(Icons.check, color: Colors.greenAccent),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              )
                  : Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text("Confirm Removal", style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),),
                              ),
                            ),
                            content: const Text(
                                "Are you sure you want to remove your friend?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  userApi.removeFriend(
                                      widget.currentId, widget.friendId);
                                  widget.onRemove();
                                },
                                child: const Text("Remove"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                        Icons.close_outlined, color: Colors.redAccent),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
