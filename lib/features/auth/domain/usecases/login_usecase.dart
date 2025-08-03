import '../repositories/login_repository.dart';
import '../../data/models/login_response.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> execute(String engineerId, String password) async {
    // Input validation
    if (engineerId.trim().isEmpty) {
      throw Exception("Engineer ID is required");
    }
    
    if (password.trim().isEmpty) {
      throw Exception("Password is required");
    }

    // Call repository
    return await repository.login(engineerId.trim(), password);
  }
}
