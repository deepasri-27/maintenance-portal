import 'package:flutter/material.dart';

class PlantResponse {
  final List<PlantItem> results;

  PlantResponse({required this.results});

  factory PlantResponse.fromJson(Map<String, dynamic> json) {
    final data = json['d'];
    final results = data['results'] as List;
    
    return PlantResponse(
      results: results.map((item) => PlantItem.fromJson(item)).toList(),
    );
  }
}

class PlantItem {
  final String maintenanceEngineer;
  final String werks;
  final String name1;
  final String stras;
  final String ort01;
  final String? metadataId;
  final String? metadataUri;
  final String? metadataType;

  PlantItem({
    required this.maintenanceEngineer,
    required this.werks,
    required this.name1,
    required this.stras,
    required this.ort01,
    this.metadataId,
    this.metadataUri,
    this.metadataType,
  });

  factory PlantItem.fromJson(Map<String, dynamic> json) {
    final metadata = json['__metadata'];
    
    return PlantItem(
      maintenanceEngineer: json['Maintenance_Engineer'] ?? '',
      werks: json['Werks'] ?? '',
      name1: json['Name1'] ?? '',
      stras: json['Stras'] ?? '',
      ort01: json['Ort01'] ?? '',
      metadataId: metadata?['id'],
      metadataUri: metadata?['uri'],
      metadataType: metadata?['type'],
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (stras.isNotEmpty) parts.add(stras);
    if (ort01.isNotEmpty) parts.add(ort01);
    return parts.isEmpty ? 'Address not available' : parts.join(', ');
  }

  Color get plantColor {
    // Generate a consistent color based on plant code
    final hash = werks.hashCode;
    return Color.fromARGB(255, (hash & 0xFF0000) >> 16, (hash & 0x00FF00) >> 8, hash & 0x0000FF);
  }
} 