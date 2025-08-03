import '../../domain/repositories/login_repository.dart';
import '../../data/datasources/login_remote_datasource.dart';
import '../../data/models/login_response.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponse> login(String engineerId, String password) async {
    try {
      final response = await remoteDataSource.login(engineerId, password);
      
      // Validate the response
      if (!response.isValid) {
        throw Exception("Invalid response from server");
      }
      
      return response;
    } catch (_) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }
}
