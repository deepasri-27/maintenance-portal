import '../../data/models/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponse> login(String engineerId, String password);
}
