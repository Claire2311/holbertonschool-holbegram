import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/models/user.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethode = AuthMethode();

  // Getter to access the user
  Users? get user => _user;

  // Method to refresh user data
  Future<void> refreshUser() async {
    Users? user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
