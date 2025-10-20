import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<UserModel> users = [];
  bool isLoading = false;
  String? error;

  String? selectedCountry; // ✅ filter state

  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      users = await _apiService.fetchUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Filtered list
  List<UserModel> get filteredUsers {
    if (selectedCountry == null || selectedCountry == 'All') return users;
    return users.where((u) => u.country == selectedCountry).toList();
  }

  // ✅ Update filter
  void setCountryFilter(String? country) {
    selectedCountry = country;
    notifyListeners();
  }

  void toggleLike(UserModel user) {
    user.isLiked = !user.isLiked;
    notifyListeners();
  }
}
