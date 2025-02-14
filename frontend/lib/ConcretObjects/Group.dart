import 'package:weski/ConcretObjects/Friend.dart';

class Group {
  late int id;
  late String name;
  late Set<Friend> groupMmembers;
  late int creator_id;

  int getId(){
    return id;
  }

  String getName(){
    return name;
  }

  int getCreator_id(){
    return creator_id;
  }

  Set<Friend> getGroupMembers(){
    return groupMmembers;
  }


  @override
  String toString() {
    String membersString = groupMmembers
        .map((friend) => friend.toString())
        .join('\n->');
    return 'Group { id: $id, creator_id: $creator_id, name: $name, members: \n->$membersString }';
  }

}
