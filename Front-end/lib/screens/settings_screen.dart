import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/mock_api_service.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 2:        Navigator.pushReplacementNamed(context, '/operational-logs');
        break;
      case 3:        break; 
    }
  }

  Widget _sectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(height: 2, color: AppColors.black, margin: const EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.1)),
          Text(value, style: const TextStyle(fontSize: 18, color: AppColors.gray800)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // To access the mock API service to get dynamic dummy data
    final apiService = MockApiService();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (i) => _onNavTap(context, i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- Device Information ----------
              _sectionHeader('Device Information'),
              _infoRow('Device ID', apiService.deviceId),
              _infoRow('Location', apiService.assignedSiteId),
              _infoRow('Site Group', apiService.siteGroupId),
              const SizedBox(height: 8),

              // ---------- Account Information ----------
              _sectionHeader('Account Information'),
              // Use dynamic user role from the login session
              _infoRow('Name', 'Test Operator'), // Placeholder name
              _infoRow('Role', apiService.currentUserRole ?? 'Not Logged In'),
              _infoRow('Contact No.', '123456789'),
              _infoRow('Email Address', 'operator@exitpass.com'),
              const SizedBox(height: 8),

              // ---------- Logout ----------
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Used toCall the mock logout function to clear session
                    apiService.logout();
                    
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logoutRed,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
