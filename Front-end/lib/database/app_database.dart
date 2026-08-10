// ignore_for_file: directives_ordering
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// Importing this bundles Drift's native SQLite engine for this platform --
// needed for any local-DB package, not Drift-specific. Windows builds need
// Developer Mode (symlinks) for path_provider/sqlite3; see AppDatabase's class doc.
// ignore: unused_import
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/incident_tables.dart';
import 'tables/manual_operation_tables.dart';
import 'tables/transaction_tables.dart';

// incident_log_screen.dart/manual_gate_log_screen.dart import table classes
// through this file rather than the individual table files -- don't drop
// these exports even though an older branch's copy of this file didn't have them.
export 'tables/incident_tables.dart';
export 'tables/manual_operation_tables.dart';
export 'tables/transaction_tables.dart';

part 'app_database.g.dart';

/// Local Drift DB: Incident/Exception/Manual-Operation epics + ContinuityTransactions
/// (incl. BCP exit-checkout payment capture). Parking-session data lives only in the
/// backend's Projections DB, looked up over the network -- ticketNumber/qrPayload here are soft pointers.
@DriftDatabase(
  tables: [
    Incidents,
    ExceptionTags,
    ManualGateLogs,
    OverrideRequests,
    ContinuityTransactions,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Singleton: prevents two live NativeDatabase connections to the same
  // sqlite file if AppDatabase() gets called from multiple screens --
  // a real corruption risk, not just style.
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal() : super(_openConnection());

  /// v1 -> v2: added ticketNumber/qrPayload to ContinuityTransactions --
  /// plain additive ADD COLUMN (both nullable), no backfill needed.
  @override
  int get schemaVersion => 2;

  /// SQLite has FK enforcement OFF by default even with references() --
  /// this turns it on so bad inserts against Incidents/ExceptionTags/
  /// ManualGateLogs -> ContinuityTransactions actually fail instead of silently succeeding.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(
                continuityTransactions, continuityTransactions.ticketNumber);
            await m.addColumn(
                continuityTransactions, continuityTransactions.qrPayload);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // Shared filter: exit-checkout ContinuityTransactions rows awaiting sync
  // (pending + has a ticketNumber). Used by the dashboard's pending count,
  // the Sync screen's list, and ExitTransactionSyncService's sync pass --
  // keeping this in one place stops those three from silently drifting apart.
  Expression<bool> get pendingExitCheckoutFilter =>
      continuityTransactions.localSyncStatus.equals(LocalSyncStatus.pending.name) &
      continuityTransactions.ticketNumber.isNotNull();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'exitpass_mops.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
