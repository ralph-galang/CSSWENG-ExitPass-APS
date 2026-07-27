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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordId': recordId,
      'reasonCode': reasonCode.name,
      'justificationText': justificationText,
      'timestamp': timestamp.toIso8601String(),
      'operatorId': operatorId,
      'deviceId': deviceId,
      'siteId': siteId,
      'laneId': laneId,
      'linkedSessionId': linkedSessionId,
      'linkedIncidentId': linkedIncidentId,
      'synced': synced,
    };
  }

  factory ManualGateLog.fromJson(Map<String, dynamic> json) {
    return ManualGateLog(
      id: json['id'] as String,
      recordId: json['recordId'] as String,
      reasonCode: ManualActionReasonCode.values.firstWhere(
        (e) => e.name == json['reasonCode'],
        orElse: () => ManualActionReasonCode.other,
      ),
      justificationText: json['justificationText'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      operatorId: json['operatorId'] as String,
      deviceId: json['deviceId'] as String,
      siteId: json['siteId'] as String,
      laneId: json['laneId'] as String?,
      linkedSessionId: json['linkedSessionId'] as String?,
      linkedIncidentId: json['linkedIncidentId'] as String?,
      synced: json['synced'] as bool? ?? false,
    );
  }
}
