import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/user_data.dart';
import 'package:weather_app/network/model_response.dart';

class SharedPreferencesService {
  final _prefs = SharedPreferences.getInstance();
  final _passKey = "password";
  final _emailKey = "email";

  Future<bool> writeUserData(UserData data) async {
    try {
      final prefs = await _prefs;
      prefs.setString(_emailKey, data.email);
      prefs.setString(_passKey, data.password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Result<UserData>> readUserData() async {
    try {
      final prefs = await _prefs;
      final email = prefs.getString(_emailKey);
      final password = prefs.getString(_passKey);
      if (email != null && password != null) {
        return Success(UserData(email: email, password: password));
      } else {
        return Error("No user data found");
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<bool> removeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_emailKey);
      prefs.remove(_passKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
