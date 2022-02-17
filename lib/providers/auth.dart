import 'dart:convert';

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/user.dart";

class AuthProvider extends ChangeNotifier {
  String? _token;
  User? _user;

  AuthProvider() {
    _loadToken();
  }

  _loadToken() {
    SharedPreferences.getInstance().then((prefs) {
      _token = prefs.getString("token");
      final user = prefs.getString("user");
      if (user != null) {
        _user = User.fromJSON(json.decode(user));
      }
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  String? get token {
    return _token;
  }

  User? get user {
    return _user;
  }

  bool get isAuth {
    return _token != null;
  }

  Future<void> authenticate(String token, User user) async {
    _token = token;
    _user = user;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("token", token);
      prefs.setString("user", json.encode(user.toJSON()));

      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("token");
      prefs.remove("user");

      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }
}
