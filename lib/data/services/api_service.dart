import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://randomuser.me/api/?results=20'),
    );
    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
