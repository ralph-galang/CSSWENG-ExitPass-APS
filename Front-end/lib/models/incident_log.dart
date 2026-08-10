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
}
