import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;

import '../ConcretObjects/User.dart';

class userApi {
  static const String url = "http://192.168.0.193:8080/api/users"; // camin
  //static const String url = "http://192.168.0.105:8080/api/users"; //acasa

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

  static Future<void> fetchFriends(int id)async {
    final endpointUrl = Uri.parse('$url/friends');
    var response;

    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      Map<String, int> encodedBody = {
        "userId": id
      };

      response = await http.post(
        endpointUrl,
        headers: headers,
        body: jsonEncode(encodedBody),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }catch(e){

    }
  }
}
