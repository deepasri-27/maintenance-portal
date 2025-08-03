import 'package:flutter/material.dart';
import '../../data/models/login_response.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;

  bool isLoading = false;
  String? error;
  LoginResponse? user;

  LoginProvider(this.loginUseCase);

  Future<bool> login(String engineerId, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await loginUseCase.execute(engineerId, password);
      isLoading = false;
      notifyListeners();
      return true; // Login successful
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false; // Login failed
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  void logout() {
    user = null;
    error = null;
    notifyListeners();
  }
}
