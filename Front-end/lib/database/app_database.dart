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

export 'tables/incident_tables.dart';
export 'tables/manual_operation_tables.dart';
export 'tables/transaction_tables.dart';

part 'app_database.g.dart';

/// Local Drift database.
///
/// SCOPE NOTE: the Priority 3 "Incident & Exception Management" and
/// "Manual Operation Support" epics are modeled here, plus a placeholder
/// for Priority 2's "Continuity Transaction Capture" (`ContinuityTransactions`)
/// since the other four tables all soft-reference a transaction ID and
/// otherwise had nothing to point at. Like the enums elsewhere in this
/// project, `ContinuityTransactions` is OUR placeholder ahead of the
/// client's schema, not a confirmed design — see the doc comment on that
/// class for what's least confident about it (the payment-related
/// columns).
///
/// Device Identity and Parking Session tables are still intentionally
/// NOT included — the client hasn't provided the session schema, and
/// Device Identity should land together with it rather than being
/// guessed at separately. Add them to the `tables:` list below once that
/// schema arrives; nothing here needs to change structurally to
/// accommodate that.
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
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// SQLite has foreign key enforcement OFF by default, even for tables
  /// declared with a `references()` constraint (Incidents/ExceptionTags/
  /// ManualGateLogs -> ContinuityTransactions). Without this, those FKs
  /// would exist in the generated schema but silently never be checked —
  /// bad inserts would succeed instead of failing.
  @override
  MigrationStrategy get migration => MigrationStrategy(
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
