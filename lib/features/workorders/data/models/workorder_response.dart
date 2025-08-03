import 'package:flutter/material.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';

class WorkOrderResponse {
  final List<WorkOrderItem> results;

  WorkOrderResponse({required this.results});

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) {
    final data = json['d'];
    final results = data['results'] as List;
    
    return WorkOrderResponse(
      results: results.map((item) => WorkOrderItem.fromJson(item)).toList(),
    );
  }
}

class WorkOrderItem {
  final String aufnr;
  final String auart;
  final String ktext;
  final String autyp;
  final String bukrs;
  final String sowrk;
  final String werks;
  final String kappl;
  final String kalsm;
  final String vaplz;
  final String kostl;
  final String? metadataId;
  final String? metadataUri;
  final String? metadataType;

  WorkOrderItem({
    required this.aufnr,
    required this.auart,
    required this.ktext,
    required this.autyp,
    required this.bukrs,
    required this.sowrk,
    required this.werks,
    required this.kappl,
    required this.kalsm,
    required this.vaplz,
    required this.kostl,
    this.metadataId,
    this.metadataUri,
    this.metadataType,
  });

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) {
    final metadata = json['__metadata'];
    
    return WorkOrderItem(
      aufnr: json['Aufnr'] ?? '',
      auart: json['Auart'] ?? '',
      ktext: json['Ktext'] ?? '',
      autyp: json['Autyp'] ?? '',
      bukrs: json['Bukrs'] ?? '',
      sowrk: json['Sowrk'] ?? '',
      werks: json['Werks'] ?? '',
      kappl: json['Kappl'] ?? '',
      kalsm: json['Kalsm'] ?? '',
      vaplz: json['Vaplz'] ?? '',
      kostl: json['Kostl'] ?? '',
      metadataId: metadata?['id'],
      metadataUri: metadata?['uri'],
      metadataType: metadata?['type'],
    );
  }

  String get orderTypeText {
    switch (auart) {
      case 'PM01':
        return 'Preventive Maintenance';
      case 'PM02':
        return 'Corrective Maintenance';
      default:
        return 'Maintenance';
    }
  }

  Color get orderTypeColor {
    switch (auart) {
      case 'PM01':
        return AppColors.secondary;
      case 'PM02':
        return AppColors.warning;
      default:
        return AppColors.textLight;
    }
  }

  String get workCenterText {
    switch (vaplz) {
      case 'INST_WC':
        return 'Installation Workshop';
      case 'MECH_WR':
        return 'Mechanical Workshop';
      default:
        return vaplz;
    }
  }

  Color get workCenterColor {
    switch (vaplz) {
      case 'INST_WC':
        return AppColors.primary;
      case 'MECH_WR':
        return AppColors.accent;
      default:
        return AppColors.textLight;
    }
  }
}
