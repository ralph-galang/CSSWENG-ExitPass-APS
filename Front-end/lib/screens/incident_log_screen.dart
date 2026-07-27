import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../models/incident_log.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../services/mock_api_service.dart';

class IncidentLogScreen extends StatefulWidget {
  const IncidentLogScreen({super.key});

  @override
  State<IncidentLogScreen> createState() => _IncidentLogScreenState();
}

class _IncidentLogScreenState extends State<IncidentLogScreen> {
  final _apiService = MockApiService();
  final _db = AppDatabase();
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  IncidentCategory? _selectedCategory;
  bool _isSubmitting = false;

  final List<IncidentLog> _incidents = [];

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Loads persisted incidents from the local database, most recent first.
  Future<void> _loadIncidents() async {
    final rows = await (_db.select(_db.incidents)
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .get();

    if (!mounted) return;
    setState(() {
      _incidents
        ..clear()
        ..addAll(rows.map(_incidentFromRow));
    });
  }

  /// Maps a persisted [Incident] row to the [IncidentLog] the UI expects.
  IncidentLog _incidentFromRow(Incident row) {
    return IncidentLog(
      id: row.id.toString(),
      recordId: row.recordId,
      category: row.category,
      description: row.notes ?? '',
      timestamp: row.occurredAt,
      operatorId: row.operatorId,
      deviceId: row.deviceId,
      siteId: row.siteId,
      synced: row.localSyncStatus == LocalSyncStatus.synced,
    );
  }

  Future<void> _submitIncident() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an incident category'),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Persist the incident to the local database.
      await _db.into(_db.incidents).insert(
            IncidentsCompanion.insert(
              recordId: const Uuid().v4(),
              category: _selectedCategory!,
              deviceId: _apiService.deviceId,
              siteId: _apiService.assignedSiteId,
              operatorId: 'ralph', // Mock operator ID
              localSyncStatus: LocalSyncStatus.pending,
              notes: Value(_descriptionController.text),
            ),
          );

      // Reload from the database so the list reflects what's actually
      // persisted (this is also how you can verify persistence: the
      // rows survive a hot restart / app relaunch).
      await _loadIncidents();

      // Clear form
      _selectedCategory = null;
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Incident logged successfully'),
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
                  'Log Incident',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Report a system issue or incident',
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
                      // Category dropdown
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<IncidentCategory>(
                        value: _selectedCategory,
                        hint: const Text('Select incident category'),
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
                        items: IncidentCategory.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.displayName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Describe the incident in detail...',
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
                            return 'Please provide a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitIncident,
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
                                'Submit Incident',
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

                // Recent incidents list
                if (_incidents.isNotEmpty) ...[
                  const Text(
                    'Recent Incidents',
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
                    itemCount: _incidents.length,
                    itemBuilder: (context, index) {
                      final incident = _incidents[index];
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
                                  incident.category.displayName,
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
                                    color: incident.synced
                                        ? AppColors.navActiveBg
                                        : AppColors.alertRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    incident.synced ? 'Synced' : 'Pending',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: incident.synced
                                          ? AppColors.navActiveText
                                          : AppColors.alertRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              incident.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gray600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              incident.formattedDateTime,
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
