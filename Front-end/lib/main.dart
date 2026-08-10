import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/scan_ticket_screen.dart';
import 'screens/manual_transaction_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/sync_transactions_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/operational_logs_screen.dart';
import 'screens/incident_log_screen.dart';
import 'screens/manual_gate_log_screen.dart';

void main() {
  runApp(const ParkingOperationsApp());
}

class ParkingOperationsApp extends StatelessWidget {
  const ParkingOperationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Operations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: null,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),

      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/tickets': (context) => const ScanTicketScreen(),
        '/manual-transaction': (context) => const ManualTransactionScreen(),
        '/ticket-detail': (context) => const TicketDetailScreen(),
        '/sync-transactions': (context) => const SyncTransactionsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/operational-logs': (context) => const OperationalLogsScreen(),
        '/incident-log': (context) => const IncidentLogScreen(),
        '/manual-gate-log': (context) => const ManualGateLogScreen(),
      },
    );
  }
}