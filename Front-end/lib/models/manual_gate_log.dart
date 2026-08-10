import 'package:intl/intl.dart';
import '../database/app_database.dart' show ManualActionReasonCode;

export '../database/app_database.dart' show ManualActionReasonCode;

extension ManualActionReasonCodeExtension on ManualActionReasonCode {
  String get displayName {
    switch (this) {
      case ManualActionReasonCode.systemDown:
        return 'System Down';
      case ManualActionReasonCode.powerOutage:
        return 'Power Outage';
      case ManualActionReasonCode.maintenance:
        return 'Maintenance';
      case ManualActionReasonCode.networkOutage:
        return 'Network Outage';
      case ManualActionReasonCode.other:
        return 'Other';
    }
  }
}

/// Model for a logged manual gate action
class ManualGateLog {
  final String id;
  final String recordId;
  final ManualActionReasonCode reasonCode;
  final String justificationText;
  final DateTime timestamp;
  final String operatorId;
  final String deviceId;
  final String siteId;
  final String? laneId;
  final String? linkedSessionId;
  final String? linkedIncidentId;
  final bool synced;

  ManualGateLog({
    required this.id,
    required this.recordId,
    required this.reasonCode,
    required this.justificationText,
    required this.timestamp,
    required this.operatorId,
    required this.deviceId,
    required this.siteId,
    this.laneId,
    this.linkedSessionId,
    this.linkedIncidentId,
    this.synced = false,
  });

  String get formattedDateTime {
    return DateFormat('MM/dd/yyyy - h:mm a').format(timestamp);
  }
}
