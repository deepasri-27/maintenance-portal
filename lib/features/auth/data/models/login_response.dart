class LoginResponse {
  final String maintenanceEngineer;
  final String password;
  final String? metadataId;
  final String? metadataUri;
  final String? metadataType;

  LoginResponse({
    required this.maintenanceEngineer,
    required this.password,
    this.metadataId,
    this.metadataUri,
    this.metadataType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['d'];
    final metadata = data['__metadata'];
    
    return LoginResponse(
      maintenanceEngineer: data['MaintenanceEngineer'] ?? '',
      password: data['Password'] ?? '',
      metadataId: metadata?['id'],
      metadataUri: metadata?['uri'],
      metadataType: metadata?['type'],
    );
  }

  bool get isValid => maintenanceEngineer.isNotEmpty && password.isNotEmpty;
}
