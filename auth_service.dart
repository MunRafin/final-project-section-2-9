import '../models/user_model.dart';

class AuthService {
  static UserModel? currentUser;

  static bool login(String name) {
    if (name.isNotEmpty) {
      currentUser = UserModel(name: name);
      return true;
    }
    return false;
  }
}