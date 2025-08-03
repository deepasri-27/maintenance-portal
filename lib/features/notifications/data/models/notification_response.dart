import 'package:flutter/material.dart';

class NotificationResponse {
  final List<NotificationItem> results;

  NotificationResponse({required this.results});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['d'];
    final results = data['results'] as List;
    
    return NotificationResponse(
      results: results.map((item) => NotificationItem.fromJson(item)).toList(),
    );
  }
}

class NotificationItem {
  final String qmnum;
  final String iwerk;
  final String iloan;
  final String equnr;
  final String ingrp;
  final String ausvn;
  final String qmart;
  final String auztv;
  final String artpr;
  final String qmtxt;
  final String priok;
  final String arbplwerk;
  final String swerk;
  final String? metadataId;
  final String? metadataUri;
  final String? metadataType;

  NotificationItem({
    required this.qmnum,
    required this.iwerk,
    required this.iloan,
    required this.equnr,
    required this.ingrp,
    required this.ausvn,
    required this.qmart,
    required this.auztv,
    required this.artpr,
    required this.qmtxt,
    required this.priok,
    required this.arbplwerk,
    required this.swerk,
    this.metadataId,
    this.metadataUri,
    this.metadataType,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final metadata = json['__metadata'];
    
    return NotificationItem(
      qmnum: json['Qmnum'] ?? '',
      iwerk: json['Iwerk'] ?? '',
      iloan: json['Iloan'] ?? '',
      equnr: json['Equnr'] ?? '',
      ingrp: json['Ingrp'] ?? '',
      ausvn: json['Ausvn'] ?? '',
      qmart: json['Qmart'] ?? '',
      auztv: json['Auztv'] ?? '',
      artpr: json['Artpr'] ?? '',
      qmtxt: json['Qmtxt'] ?? '',
      priok: json['Priok'] ?? '',
      arbplwerk: json['Arbplwerk'] ?? '',
      swerk: json['Swerk'] ?? '',
      metadataId: metadata?['id'],
      metadataUri: metadata?['uri'],
      metadataType: metadata?['type'],
    );
  }

  String get priorityText {
    switch (priok) {
      case '1':
        return 'High';
      case '2':
        return 'Medium';
      case '3':
        return 'Low';
      default:
        return 'Not Set';
    }
  }

  Color get priorityColor {
    switch (priok) {
      case '1':
        return Colors.red;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get formattedDate {
    if (ausvn.isEmpty) return 'No date';
    
    // Parse SAP date format: /Date(1749513600000)/
    try {
      final dateStr = ausvn.replaceAll('/Date(', '').replaceAll(')/', '');
      final timestamp = int.parse(dateStr);
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }
} 