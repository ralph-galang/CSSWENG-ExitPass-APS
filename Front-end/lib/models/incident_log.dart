import 'package:intl/intl.dart';
import '../database/app_database.dart' show IncidentCategory;

export '../database/app_database.dart' show IncidentCategory;

extension IncidentCategoryExtension on IncidentCategory {
  String get displayName {
    switch (this) {
      case IncidentCategory.systemDown:
        return 'System Down';
      case IncidentCategory.powerOutage:
        return 'Power Outage';
      case IncidentCategory.hardwareFailure:
        return 'Hardware Failure';
      case IncidentCategory.networkFailure:
        return 'Network Failure';
      case IncidentCategory.maintenance:
        return 'Maintenance';
      case IncidentCategory.other:
        return 'Other';
    }
  }
}

/// Model for a logged incident
class IncidentLog {
  final String id;
  final String recordId;
  final IncidentCategory category;
  final String description;
  final DateTime timestamp;
  final String operatorId;
  final String deviceId;
  final String siteId;
  final String? laneId;
  final String? linkedSessionId;
  final bool synced;

  IncidentLog({
    required this.id,
    required this.recordId,
    required this.category,
    required this.description,
    required this.timestamp,
    required this.operatorId,
    required this.deviceId,
    required this.siteId,
    this.laneId,
    this.linkedSessionId,
    this.synced = false,
  });

  String get formattedDateTime {
    return DateFormat('MM/dd/yyyy - h:mm a').format(timestamp);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordId': recordId,
      'category': category.name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'operatorId': operatorId,
      'deviceId': deviceId,
      'siteId': siteId,
      'laneId': laneId,
      'linkedSessionId': linkedSessionId,
      'synced': synced,
    };
  }

  factory IncidentLog.fromJson(Map<String, dynamic> json) {
    return IncidentLog(
      id: json['id'] as String,
      recordId: json['recordId'] as String,
      category: IncidentCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => IncidentCategory.other,
      ),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      operatorId: json['operatorId'] as String,
      deviceId: json['deviceId'] as String,
      siteId: json['siteId'] as String,
      laneId: json['laneId'] as String?,
      linkedSessionId: json['linkedSessionId'] as String?,
      synced: json['synced'] as bool? ?? false,
    );
  }
}
