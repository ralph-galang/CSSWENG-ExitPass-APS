import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// The DB's generated row class for ManualGateLogs is ALSO named
// `ManualGateLog` (see @DataClassName in manual_operation_tables.dart),
// which collides with the UI model class of the same name below. We
// don't need to reference that generated type by name here (see the
// `dynamic row` param in _logFromRow), so it's hidden rather than
// aliased.
import '../database/app_database.dart' hide ManualGateLog;
import '../models/manual_gate_log.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../services/mock_api_service.dart';

class ManualGateLogScreen extends StatefulWidget {
  const ManualGateLogScreen({super.key});

  @override
  State<ManualGateLogScreen> createState() => _ManualGateLogScreenState();
}

class _ManualGateLogScreenState extends State<ManualGateLogScreen> {
  final _apiService = MockApiService();
  final _db = AppDatabase();
  final _formKey = GlobalKey<FormState>();
  final _justificationController = TextEditingController();

  ManualActionReasonCode? _selectedReason;
  bool _isSubmitting = false;

  final List<ManualGateLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  /// Loads persisted manual gate logs from the local database, most
  /// recent first.
  Future<void> _loadLogs() async {
    final rows = await (_db.select(_db.manualGateLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.performedAt)]))
        .get();

    if (!mounted) return;
    setState(() {
      _logs
        ..clear()
        ..addAll(rows.map(_logFromRow));
    });
  }

  /// Maps a persisted [ManualGateLog] (Drift row) to the UI model.
  ManualGateLog _logFromRow(dynamic row) {
    return ManualGateLog(
      id: row.id.toString(),
      recordId: row.recordId,
      reasonCode: row.reasonCode ?? ManualActionReasonCode.other,
      justificationText: row.justificationText,
      timestamp: row.performedAt,
      operatorId: row.operatorId,
      deviceId: row.deviceId,
      siteId: row.siteId,
      laneId: row.lane,
      linkedIncidentId: row.linkedIncidentId,
      synced: row.localSyncStatus == LocalSyncStatus.synced,
    );
  }

  Future<void> _submitLog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason'),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Persist the manual gate log to the local database.
      // `lane` is required by the schema but there's no lane concept
      // wired up elsewhere in this app yet — using a placeholder until
      // that's added.
      await _db.into(_db.manualGateLogs).insert(
            ManualGateLogsCompanion.insert(
              recordId: const Uuid().v4(),
              idempotencyKey: const Uuid().v4(),
              justificationText: _justificationController.text,
              reasonCode: Value(_selectedReason),
              operatorId: 'ralph', // Mock operator ID
              deviceId: _apiService.deviceId,
              siteId: _apiService.assignedSiteId,
              lane: 'N/A',
              localSyncStatus: LocalSyncStatus.pending,
            ),
          );

      // Reload from the database so the list reflects what's actually
      // persisted (this is also how you can verify persistence: the
      // rows survive a hot restart / app relaunch).
      await _loadLogs();

      // Clear form
      _selectedReason = null;
      _justificationController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Manual gate action logged successfully'),
          backgroundColor: AppColors.navActiveText,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const AppIcon(
                        svg: AppIcons.chevronRight,
                        size: 20,
                        color: AppColors.gray400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.navActiveText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Log Manual Gate Action',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Record a manual gate operation or override',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 24),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Reason dropdown
                      const Text(
                        'Reason for Manual Action',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ManualActionReasonCode>(
                        value: _selectedReason,
                        hint: const Text('Select reason'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: AppColors.gray300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: ManualActionReasonCode.values
                            .map((reason) => DropdownMenuItem(
                                  value: reason,
                                  child: Text(reason.displayName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedReason = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a reason';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Justification field
                      const Text(
                        'Justification',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _justificationController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'Provide justification for this manual action...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                                const BorderSide(color: AppColors.gray300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide justification';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitLog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navActiveText,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          disabledBackgroundColor: AppColors.gray300,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Submit Gate Action Log',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // Recent logs list
                if (_logs.isNotEmpty) ...[
                  const Text(
                    'Recent Gate Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.gray200,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.reasonCode.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray900,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: log.synced
                                        ? AppColors.navActiveBg
                                        : AppColors.alertRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    log.synced ? 'Synced' : 'Pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: log.synced
                                          ? AppColors.navActiveText
                                          : AppColors.alertRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              log.justificationText,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gray600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              log.formattedDateTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
