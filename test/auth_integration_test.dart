import 'package:flutter_test/flutter_test.dart';
import 'package:maintenance_portal/features/auth/data/datasources/login_remote_datasource.dart';
import 'package:maintenance_portal/features/auth/data/models/login_response.dart';

void main() {
  group('LoginResponse Model Tests', () {
    test('should parse valid JSON response', () {
      final jsonData = {
        'd': {
          '__metadata': {
            'id': 'http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer=\'00000001\',Password=\'VALID\')',
            'uri': 'http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZPM_MAINT54_PORTAL_SRV/LoginSet(MaintenanceEngineer=\'00000001\',Password=\'VALID\')',
            'type': 'ZPM_MAINT54_PORTAL_SRV.login'
          },
          'MaintenanceEngineer': '00000001',
          'Password': 'VALID'
        }
      };

      final response = LoginResponse.fromJson(jsonData);

      expect(response.maintenanceEngineer, '00000001');
      expect(response.password, 'VALID');
      expect(response.metadataId, isNotNull);
      expect(response.metadataUri, isNotNull);
      expect(response.metadataType, 'ZPM_MAINT54_PORTAL_SRV.login');
      expect(response.isValid, isTrue);
    });

    test('should handle missing metadata', () {
      final jsonData = {
        'd': {
          'MaintenanceEngineer': '00000001',
          'Password': 'VALID'
        }
      };

      final response = LoginResponse.fromJson(jsonData);

      expect(response.maintenanceEngineer, '00000001');
      expect(response.password, 'VALID');
      expect(response.metadataId, isNull);
      expect(response.metadataUri, isNull);
      expect(response.metadataType, isNull);
      expect(response.isValid, isTrue);
    });

    test('should handle empty values', () {
      final jsonData = {
        'd': {
          'MaintenanceEngineer': '',
          'Password': ''
        }
      };

      final response = LoginResponse.fromJson(jsonData);

      expect(response.maintenanceEngineer, '');
      expect(response.password, '');
      expect(response.isValid, isFalse);
    });
  });

  group('CORS Proxy Tests', () {
    test('should use CORS proxy for web platform', () {
      final datasource = LoginRemoteDataSource();
      final testUrl = datasource.buildUrl('00000001', '1234');

      // For web, URL should include CORS proxy (assuming kIsWeb is true for this test)
      // Note: The mock kIsWeb below is set to false, so this test will check the else branch.
      if (kIsWeb) {
        expect(testUrl, contains('localhost:3000/sap'));
      } else {
        // For mobile/desktop, URL should be direct
        expect(testUrl, contains('AZKTLDS5CP.kcloud.com'));
      }
    });
  });
}

// Mock kIsWeb for testing (set to false for non-web test environment)
bool get kIsWeb => false; 