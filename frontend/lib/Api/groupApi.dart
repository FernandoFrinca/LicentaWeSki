import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weski/ConcretObjects/Group.dart';

import '../ConcretObjects/Friend.dart';
import 'consts.dart';

class groupApi {
  static const String url = "$ipAddres/group";
  static Future<List<Group>> fetchUserGroups(int id)async {
    final endpointUrl = Uri.parse('$url/getUserGroups/$id');
    final response = await http.get(endpointUrl);
    if (response.statusCode != 200) {
      print("Eroare la API: ${response.statusCode}");
      return [];
    }
    try {
      List<dynamic> decodedBody = jsonDecode(response.body);
      List<Group> groupsList = [];
      for(var body in decodedBody){
        Group group = Group();
        group.id = body['id'];
        group.creator_id = body['creator_id'];
        group.name = body['name'];

        Set<Friend> friendsSet = new HashSet();
        for (var user in body['users']) {
          Friend friend = Friend();
          friend.id = user['id'];
          friend.username = user['username'];
          friend.category = user['category'];
          friendsSet.add(friend);
        }
        group.groupMmembers = friendsSet;
        print(group);
        groupsList.add(group);
      }
      return groupsList;
    }catch(e){
      return [];
    }
  }

  static Future<Group?> fetchGroup(int id) async {
    final endpointUrl = Uri.parse('$url/getGroupById/$id');
    final response = await http.get(endpointUrl);

    if (response.statusCode != 200) {
      print("Eroare la API: ${response.statusCode}");
      return null;
    }

    try {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);

      Group group = Group();
      group.id = decodedBody['id'];
      group.creator_id = decodedBody['creator_id'];
      group.name = decodedBody['name'];

      Set<Friend> friendsSet = HashSet<Friend>();
      for (var user in decodedBody['groupMembers']) {
        Friend friend = Friend();
        friend.id = user['id'];
        friend.username = user['username'];
        friend.category = user['category'];
        friendsSet.add(friend);
      }
      group.groupMmembers = friendsSet;
      return group;
    } catch (e) {
      print("Eroare la grup: $e");
      return null;
    }
  }


  static Future<int> createGroup(String groupName, int userId) async{
    final endpointUrl = Uri.parse('$url/createGroup/$groupName/by/$userId');
    final response = await http.post(endpointUrl);
    try {
      if(response.statusCode == 200){
        print("\n");
        print(groupName);
        print(userId);
        print("\n");
        final groupId = int.parse(response.body);
        print("Grup creat cu succes: $groupId");
        return groupId;
      }
      throw Exception("Eroare la crearea grupului");
    }catch(e){
        print("eroare la cerare grupului");
        throw Exception("Parsarea id-ului grupului a eșuat");
    }
  }


  static Future<void> addUserToGroup(int userId, int groupId) async{
    final endpointUrl = Uri.parse('$url/addUser/$userId/to/$groupId');
    final response = await http.post(endpointUrl);
    try {
      if(response.statusCode == 200){
        print("user adaugat cu succes");
      }
    }catch(e){
      print("eroare la adaugarea user");
    }
  }

  static Future<void> addUsersToGroup(int groupId, Set<int> users) async{
    final endpointUrl = Uri.parse('$url/$groupId/AddUsers');

    final response = await http.post(
      endpointUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(users.toList()),
    );

    if(response.statusCode == 200){
      print("users adaugati cu succes");
    }else{
      print("users nu au fost adaugati");
    }
  }

  static Future<void> removeGroup(int groupId) async{
    final endpointUrl = Uri.parse('$url/deleteGroup/$groupId');
    final response = await http.delete(endpointUrl);
    try {
      if (response.statusCode == 200) {
        print('Sters!');
      } else {
        print('Eroare la stergere');
      }
    }
    catch(e){
      print('Eroare la stergere: $e');
    }
  }

  static Future<void> removeUserFromGroup(int groupId, int userId)async {
    final endpointUrl = Uri.parse('$url/from/$groupId/delete/$userId');
    final response = await http.delete(endpointUrl);
    try {
      if (response.statusCode == 200) {
        print('Sters!');
      } else {
        print('Eroare la stergere');
      }
    }
    catch(e){
      print('Eroare la stergere: $e');
    }
  }

}
