import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      'http://192.168.187.182:8000/api'; // Replace with your actual API URL

  Future<Map<String, dynamic>> login(String name, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Invalid Credentials');
    }
  }

  Future<Map<String, dynamic>> fetchSelf(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/self'), // Replace with your actual user info endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('user')) {
        return responseBody['user']; // Return the user object
      } else {
        throw Exception('User data not found in response');
      }
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  // Create
  Future<Map<String, dynamic>> createItem(
      String token, Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse(
          '$apiUrl/items'), // Replace with your actual create item endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(item),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create item');
    }
  }

  // Read
  Future<Map<String, dynamic>> readItem(String token, int itemId) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/items/$itemId'), // Replace with your actual read item endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch item');
    }
  }

  // Update
  Future<Map<String, dynamic>> updateItem(
      String token, int itemId, Map<String, dynamic> item) async {
    final response = await http.put(
      Uri.parse(
          '$apiUrl/items/$itemId'), // Replace with your actual update item endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(item),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update item');
    }
  }

  // Delete
  Future<void> deleteItem(String token, int itemId) async {
    final response = await http.delete(
      Uri.parse(
          '$apiUrl/items/$itemId'), // Replace with your actual delete item endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }
}
