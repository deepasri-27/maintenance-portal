import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';

class LoginRemoteDataSource {
  // For web development, we need to use the full URL since Flutter dev server doesn't proxy
  final String baseUrl = kIsWeb 
      ? "http://localhost:3000/sap"  // Use our proxy server
      : "http://AZKTLDS5CP.kcloud.com:8000";  // Direct SAP URL
  
  // SAP Basic Authentication credentials
  final String sapUsername = "K901554";
  final String sapPassword = "Deepasri@27";

  // Helper method for testing URL construction
  String buildUrl(String engineerId, String password) {
    final encodedEngineerId = Uri.encodeComponent(engineerId);
    final encodedPassword = Uri.encodeComponent(password);
    
    return "$baseUrl/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='$encodedEngineerId',Password='$encodedPassword')?\$format=json";
  }

  Future<LoginResponse> login(String engineerId, String password) async {
    try {
      // URL encode the parameters to handle special characters
      final encodedEngineerId = Uri.encodeComponent(engineerId);
      final encodedPassword = Uri.encodeComponent(password);
      
      // Build the SAP API URL - removed extra /sap from the path
      final url = "$baseUrl/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer='$encodedEngineerId',Password='$encodedPassword')?\$format=json";

      print('Making request to: $url'); // Debug log

      // Create Basic Authentication header
      final basicAuth = base64Encode(utf8.encode("$sapUsername:$sapPassword"));

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Basic $basicAuth",
        },
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception("Invalid credentials. Please check your Engineer ID and Password.");
      } else if (response.statusCode == 403) {
        throw Exception("Access forbidden. Please check your SAP authentication credentials.");
      } else if (response.statusCode == 404) {
        throw Exception("Login service not found. Please contact administrator.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception("Login failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
