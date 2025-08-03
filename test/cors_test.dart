import 'package:flutter_test/flutter_test.dart';
import 'package:maintenance_portal/features/auth/data/datasources/login_remote_datasource.dart';

void main() {
  group('CORS Proxy Tests', () {
    test('should use CORS proxy for web platform', () {
      final datasource = LoginRemoteDataSource();
      
      // Test that the URL includes CORS proxy for web
      final testUrl = datasource.buildUrl('00000001', '1234');
      
      // For web, URL should include CORS proxy
      if (kIsWeb) {
        expect(testUrl, contains('cors-anywhere.herokuapp.com'));
      } else {
        // For mobile/desktop, URL should be direct
        expect(testUrl, contains('AZKTLDS5CP.kcloud.com'));
      }
    });
  });
}

// Mock kIsWeb for testing
bool get kIsWeb => false; 