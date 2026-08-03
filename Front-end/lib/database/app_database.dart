// ignore_for_file: directives_ordering
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// Not referenced directly — importing it is what makes Drift bundle the
// native SQLite engine for this platform. See the module-level note below
// about what this means for Windows builds.
// ignore: unused_import
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/incident_tables.dart';
import 'tables/manual_operation_tables.dart';
import 'tables/transaction_tables.dart';

// Required by incident_log_screen.dart / manual_gate_log_screen.dart,
// which import table classes (Incidents, ManualGateLogs, etc.) through
// this file rather than the individual table files directly. Don't drop
// these even though the BCP exit-sync branch's copy of this file didn't
// have them — that branch just didn't have those screens to need them.
export 'tables/incident_tables.dart';
export 'tables/manual_operation_tables.dart';
export 'tables/transaction_tables.dart';

part 'app_database.g.dart';

/// Local Drift database.
///
/// SCOPE NOTE: the Priority 3 "Incident & Exception Management" and
/// "Manual Operation Support" epics are modeled here, plus
/// `ContinuityTransactions` for Priority 2's "Continuity Transaction
/// Capture" — including, as of schema v2, the BCP exit-checkout flow
/// (Epic 5 continuity payment capture during a scan/enter-ticket exit).
/// Like the enums elsewhere in this project, `ContinuityTransactions` is
/// OUR placeholder ahead of the client's schema, not a confirmed design —
/// see the doc comment on that class for what's least confident about it
/// (the payment-related columns).
///
/// Device Identity and Parking Session tables are still intentionally
/// NOT included as *local* tables — parking session data lives only in
/// the backend's Projections DB and is looked up over the network per the
/// architecture note in V3__add_projections_schema_simulation.sql, never
/// mirrored on-device. `ContinuityTransactions.ticketNumber` /
/// `.qrPayload` are the local pointer back to that remote session, not a
/// local copy of it.
///
/// WINDOWS BUILD NOTE — please read before running `flutter pub get`:
/// pubspec.yaml has an existing comment explaining that `google_fonts`
/// was removed because it pulls in `path_provider`, which needs Windows
/// Developer Mode / symlink support to build. Any real local database
/// needs the same category of native plugin (something has to locate a
/// writable file path and load a native SQLite engine) — this file adds
/// both `path_provider` and `sqlite3_flutter_libs` back in. That's not
/// specific to Drift; sqflite or any other local-DB package would need
/// the same thing. Two ways to handle it:
///   1. Accept Developer Mode is needed for Windows builds going forward
///      — reasonable, since offline-first local storage is required by
///      nearly the whole backlog, not optional.
///   2. Keep Windows desktop for UI-only iteration: guard database
///      initialization behind `Platform.isAndroid` (or similar) and test
///      DB-backed screens on an Android emulator/device instead, since
///      the SOW's actual production target is Android only anyway.
/// Test a clean `flutter run -d windows` after adding these dependencies
/// to see which situation you're actually in before deciding.
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
  // Singleton: both branches otherwise open their own LazyDatabase
  // connection to the same sqlite file if AppDatabase() gets called more
  // than once (e.g. from two different screens' initState). Keeping this
  // from the operational-logs branch rather than the plain constructor
  // the sync branch had -- multiple live connections to one SQLite file
  // is a real bug risk, not just a style preference.
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal() : super(_openConnection());

  /// v1 -> v2: added `ticketNumber` and `qrPayload` to
  /// `ContinuityTransactions`, for the BCP exit-checkout sync workflow.
  /// Both are nullable `TextColumn`s, so this is a plain additive
  /// `ALTER TABLE ... ADD COLUMN` — no backfill needed, no data loss risk
  /// for existing rows from other continuity flows.
  @override
  int get schemaVersion => 2;

  /// SQLite has foreign key enforcement OFF by default, even for tables
  /// declared with a `references()` constraint (Incidents/ExceptionTags/
  /// ManualGateLogs -> ContinuityTransactions). Without this, those FKs
  /// would exist in the generated schema but silently never be checked —
  /// bad inserts would succeed instead of failing.
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'exitpass_mops.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
