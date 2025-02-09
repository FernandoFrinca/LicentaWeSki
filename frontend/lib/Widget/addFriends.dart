import 'package:flutter/material.dart';
import 'package:weski/Api/userApi.dart';
import 'package:weski/Widget/CustomTextField.dart';

class addFriends extends StatefulWidget {
  final TextEditingController friendController;
  final int currentUserId;

  const addFriends({
    Key? key,
    required this.friendController,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<addFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<addFriends> {
  String? errorMessage;
    //final TextEditingController _friendController = TextEditingController();
  @override
  void dispose() {
    widget.friendController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
       child: Container(
         height: 200,
         width: 600,
         child: Column(
           children: [
             const Padding(
               padding: EdgeInsets.all(8.0),
               child: Text("Add Friends", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
             ),
             Container(
               width: 320,
               child: CustomTextField(
                   label: "Username",
                   controller: widget.friendController,
                   icon: Icons.person_2_outlined,
                   borderColor: theme.colorScheme.onPrimary.value,
                   fillColor: theme.colorScheme.secondary.value,
                   iconColor: theme.colorScheme.primary.value,
                   texColor: theme.colorScheme.onSecondary.value,
                   borderRadius: 18,
                   errorState: false,
               ),
             ),
             SizedBox(
               height: 15,
               child: errorMessage != null
                   ? Text(
                 errorMessage!,
                 style: const TextStyle(color: Colors.red),
               )
                   : null,
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
                   if(await userApi.addFriendByUsername(widget.currentUserId,widget.friendController.text) == false){
                     setState(() {
                       errorMessage = "Eroare la adăugarea userului!";
                     });
                   }else{
                     setState(() {
                       widget.friendController.clear();
                     });
                   }
                 },
                 child: const Text(
                   "Add",
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