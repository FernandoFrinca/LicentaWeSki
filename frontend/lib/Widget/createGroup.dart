import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:weski/Api/groupApi.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Widget/CustomTextField.dart';

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

  @override
  void dispose() {
    widget.groupController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        height: 600,
        width: 600,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Create Group",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 320,
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


/*
* imi ramane sa fac pagina de grup
* dau leave la grup
* sterg grupul
* scriu ceva la grup maybe
* notific grupul
* sa dau fetch la o poza calumea
* sa fac asta si la prieteni
* */