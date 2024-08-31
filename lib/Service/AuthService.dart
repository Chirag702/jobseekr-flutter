import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('Local storage cleared.');
      return true;
    } catch (e) {
      print('Error clearing local storage: $e');
      return false;
    }
  }

  // You can add other methods for interacting with local storage here, e.g., saving, retrieving data, etc.
}
