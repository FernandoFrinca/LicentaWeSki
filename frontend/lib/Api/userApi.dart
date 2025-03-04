import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:weski/ConcretObjects/Friend.dart';

import '../ConcretObjects/Statistics.dart';
import '../ConcretObjects/User.dart';
import 'consts.dart';

class userApi {
  static const String url = "$ipAddres/users";
  static Future<List?> fetchAllUsers() async {
    final endpointUrl = Uri.parse('$url/getAll');
    try {
      final response = await http.get(endpointUrl);
      final decodedBody = jsonDecode(response.body);
      return decodedBody;
    } catch (e) {
      print("Exception catch users");
      return null;
    }
  }

  static Future<void> registerUser(String username, String email,
      String password, String category) async {
    final endpointUrl = Uri.parse('$url/post');
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      final encodedBody = {
        "username": username,
        "email": email,
        "password": password,
        "category": category,
      };

      final response = await http.post(
        endpointUrl,
        headers: headers,
        body: jsonEncode(encodedBody),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    catch (e) {
      print("Eroare la creare user: $e");
    }
  }


  static Future<User?> userLoginValidation(String username,
      String password) async {
    final endpointUrl = Uri.parse('$url/login');
    var response;

    User user = User();
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      Map<String, String> encodedBody = {
        "username": username,
        "password": password,
      };

      response = await http.post(
        endpointUrl,
        headers: headers,
        body: jsonEncode(encodedBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        user.id = decodedResponse['id'];
        user.username = decodedResponse['username'];
        user.email = decodedResponse['email'];
        user.age = decodedResponse['age'] ?? 0;
        user.gender = decodedResponse['gender'] ?? 2;
        user.category = decodedResponse['category'];
        print("User actualizat: $user");
        return user;
      } else {
          print("Status code diferit de 200, autentificare eșuată.");
          return null;
        }
      } catch (e) {
        print("Eroare la login: $e");
        return null;
      }
  }

  static Future<void> resetPassword(int userId,String password, String verifyPassword)async {
    final endpointUrl = Uri.parse('$url/$userId/resetPassword/$password/$verifyPassword');
    try {
      final response = await http.patch(endpointUrl);
      print('Status code: ${response.statusCode}');
    }
    catch(e){
      return;
    }
  }

  static Future<void> updateUser(int idUser, User user) async {
    final endpointUrl = Uri.parse('$url/$idUser/updateData');
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      final encodedBody = {
        "username": user.username,
        "email": user.email,
        "category": user.category,
        "age": user.age,
        "gender": user.gender
      };

      final response = await http.patch(
        endpointUrl,
        headers: headers,
        body: jsonEncode(encodedBody),
      );

      if (response.statusCode != 200) {
        throw Exception('eroare la user: ${response.statusCode}');
      }
    } catch (e) {
      print('catch updateUser: $e');
      rethrow;
    }
  }


  static Future<List<Friend>> fetchFriends(int id)async {
    final endpointUrl = Uri.parse('$url/$id/friends');
    final response = await http.get(endpointUrl);
    try {

      List<dynamic> decodedBody = jsonDecode(response.body);
      List<Friend> friendsList = [];
      for(var body in decodedBody){
        Friend friend = Friend();
        friend.id = body['id'];
        friend.username = body['username'];
        friend.category = body['category'];

        //print(friend.username);
        friendsList.add(friend);
      }

      /*for(var friend in friendsList){
        print("${friend.username}, ${friend.category}, ${friend.id}");
      }*/
      return friendsList;
    }catch(e){
      return [];
    }
  }

  static Future<List<Friend>> fetchFriendRequests(int id)async {
    final endpointUrl = Uri.parse('$url/$id/requests');
    final response = await http.get(endpointUrl);
    try {

      List<dynamic> decodedBody = jsonDecode(response.body);
      List<Friend> requestsList = [];
      for(var body in decodedBody){
        Friend request = Friend();
        request.id = body['id'];
        request.username = body['username'];
        request.category = body['category'];

        requestsList.add(request);
      }
      return requestsList;
    }catch(e){
      return [];
    }
  }

  static Future<bool> addFriendByUsername(int currentId, String username) async{
    final endpointUrl = Uri.parse('$url/$currentId/requestFriend/$username');
    final response = await http.post(endpointUrl);
    try {
      if (response.statusCode == 200) {
        print('Prieten adăugat cu succes!');
        return true;
      } else {
        print('Eroare la adăugarea prietenului.');
        return false;
      }
    }
    catch(e){
      print('Eroare la request: $e');
      return false;
    }
  }

  static Future<void> respondeRequest(int currentId, int friendID, bool state)async{
    final endpointUrl = Uri.parse('$url/$currentId/requestResponse/$friendID/$state');
    final response = await http.put(endpointUrl);
    try {
      if (response.statusCode == 200) {
        print('Cerere raspunsa!');
      } else {
        print('Eroare la raspunsul cereri');
      }
    }
    catch(e){
      print('Eroare la raspunsul cereri: $e');
    }
  }

  static Future<void> removeFriend(int currentId, int friendID)async{
    final endpointUrl = Uri.parse('$url/$currentId/deleteFriend/$friendID');
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

  static Future<void> updateStatistics(int userId, double total_distance, double max_speed) async{
    final endpointUrl = Uri.parse('$url/$userId/updateStatistics/$total_distance/$max_speed');
    final response = await http.post(endpointUrl);
    try {
      if (response.statusCode == 200) {
        print('Statistica Updatata!');
      } else {
        print('Eroare la update');
      }
    }
    catch(e){
      print('Eroare la update: $e');
    }
  }

  static Future<List<Statistics>>getGroupStatistics(int groupId)async {
    final endpointUrl = Uri.parse('$url/getGroupStatistics/$groupId');
    final response = await http.get(endpointUrl);
    try {

      List<dynamic> decodedBody = jsonDecode(response.body);
      List<Statistics> statisticssList = [];
      for(var body in decodedBody){
        Statistics statistica = Statistics();
        statistica.user_id = body['user_id'];
        statistica.max_speed = body['max_speed'];
        statistica.total_distance = body['total_distance'];
        statisticssList.add(statistica);
      }
      return statisticssList;
    }catch(e){
      return [];
    }
  }

}
