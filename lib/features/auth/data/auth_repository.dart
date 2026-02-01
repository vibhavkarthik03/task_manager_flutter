import '../../../core/storage/local_storage.dart';


class AuthRepository {
  final LocalStorage storage;


  AuthRepository(this.storage);


  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));


    if (email == "test@test.com" && password == "123456") {
      await storage.saveLogin();
      return true;
    }


    return false;
  }


  Future<void> logout() async {
    await storage.clearLogin();
  }


  Future<bool> checkSession() => storage.isLoggedIn();
}
