import 'package:flutter/material.dart';

class groupCard extends StatelessWidget {
  final double cardHeight;
  final String groupName;
  final String groupPhoto;
  final VoidCallback onTap;

  const groupCard({
    Key? key,
    required this.cardHeight,
    required this.groupName,
    required this.groupPhoto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: screenWidth * 0.3,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                groupPhoto == "empty" ?
                  Image.asset(
                    "assets/ski.jpeg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ):
                  Image.network(groupPhoto,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.25),
                ),
                Positioned(
                  bottom: cardHeight * 0.1,
                  left: 10,
                  right: 10,
                  child: Text(
                    "Group $groupName",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
