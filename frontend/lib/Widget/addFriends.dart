import 'package:flutter/material.dart';
import 'package:weski/Widget/CustomTextField.dart';

class addFriends extends StatelessWidget {

  final TextEditingController friendController;
  const addFriends({
    super.key,
    required this.friendController,
  });
  //color: Color(0xFF007EA7),
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final TextEditingController _friendController = TextEditingController();
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
                   controller: friendController,
                   icon: Icons.person_2_outlined,
                   borderColor: theme.colorScheme.onPrimary.value,
                   fillColor: theme.colorScheme.secondary.value,
                   iconColor: theme.colorScheme.primary.value,
                   texColor: theme.colorScheme.onSecondary.value,
                   borderRadius: 18,
                   errorState: false,
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(
                 top: 16,
               ),
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: theme.colorScheme.primary,
                 ),
                 onPressed: () {},
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