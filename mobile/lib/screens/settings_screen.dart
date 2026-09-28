import 'package:flutter/material.dart';

import '../models/diagnostic_state.dart';
import '../services/api_service.dart';
import 'usage_screen.dart';

class SettingsScreen extends StatelessWidget {
  final DiagnosticState diagnosticState;

  const SettingsScreen({
    super.key,
    required this.diagnosticState,
  });

  static const Color brand500 = Color(0xFF0EA5E9);
  static const Color brand600 = Color(0xFF0284C7);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);

  TextStyle _text(
    double size,
    FontWeight weight,
    Color color,
  ) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  void _logout(BuildContext context) {
    ApiService.clearSession();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _editData(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => UsageScreen(
          state: diagnosticState,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  void _clearData(BuildContext context) {
    diagnosticState.monthlyUsageM3 = 20;
    diagnosticState.usageHours = ['morning', 'evening'];
    diagnosticState.fixtureCount = 1;
    diagnosticState.primaryFixture = '';

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Diagnostic data cleared.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ApiService.currentEmail ?? 'Authenticated account';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE0F2FE),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: slate800,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'LEAKLENS',
                    style: _text(18, FontWeight.w800, brand600),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Profile & Settings',
                style: _text(28, FontWeight.w800, slate800),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your LEAKLENS session and diagnostic data.',
                style: _text(14, FontWeight.w400, slate500),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFE0F2FE),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [brand500, brand600],
                        ),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signed in',
                            style: _text(13, FontWeight.w700, slate500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            overflow: TextOverflow.ellipsis,
                            style: _text(15, FontWeight.w700, slate800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _actionCard(
                context,
                icon: Icons.edit_outlined,
                title: 'Edit diagnostic data',
                subtitle: 'Return to usage setup and change your answers.',
                onTap: () => _editData(context),
              ),

              const SizedBox(height: 12),

              _actionCard(
                context,
                icon: Icons.delete_outline,
                title: 'Clear diagnostic data',
                subtitle: 'Reset the current diagnostic inputs.',
                onTap: () => _clearData(context),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
                  label: Text(
                    'Log Out',
                    style: _text(
                      15,
                      FontWeight.w700,
                      const Color(0xFFDC2626),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0F2FE)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: brand500, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _text(14, FontWeight.w700, slate800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: _text(12, FontWeight.w400, slate500),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: slate500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
