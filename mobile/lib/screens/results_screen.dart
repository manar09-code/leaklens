import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/diagnostic_state.dart';

class ResultsScreen extends StatefulWidget {
  final DiagnosticState diagnosticState;

  const ResultsScreen({
    super.key,
    required this.diagnosticState,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  static const Color brand500 = Color(0xFF0EA5E9);
  static const Color brand600 = Color(0xFF0284C7);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);

  bool loading = true;
  String? error;

  bool leakDetected = false;
  int confidence = 0;
  double wasteLiters = 0;
  double monthlyCost = 0;
  String suspectedFixture = '';
  String explanation = '';

  @override
  void initState() {
    super.initState();
    _runDiagnostic();
  }

  Future<void> _runDiagnostic() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.7:8000/api/diagnostic'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(widget.diagnosticState.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('API returned ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (!mounted) return;

      setState(() {
        leakDetected = data['leak_detected'] == true;
        confidence = (data['confidence'] ?? 0).toInt();
        wasteLiters =
            (data['estimated_waste_liters_per_day'] ?? 0).toDouble();
        monthlyCost =
            (data['estimated_monthly_cost_dt'] ?? 0).toDouble();
        suspectedFixture =
            data['suspected_fixture']?.toString() ?? '';
        explanation =
            data['explanation']?.toString() ?? '';
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = 'Unable to connect to the LEAKLENS backend.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: loading
            ? _buildLoading()
            : error != null
                ? _buildError()
                : _buildResults(),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              color: brand500,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing your water usage...',
            style: _text(
              16,
              FontWeight.w700,
              slate800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'LEAKLENS is checking for anomalies.',
            style: _text(
              13,
              FontWeight.w400,
              slate500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Color(0xFFDC2626),
            ),
            const SizedBox(height: 18),
            Text(
              'Connection failed',
              style: _text(
                22,
                FontWeight.w800,
                slate800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: _text(
                14,
                FontWeight.w400,
                slate500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  error = null;
                });
                _runDiagnostic();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brand500,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final resultColor = leakDetected
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 30),

          Text(
            'Diagnostic Results',
            style: _text(
              28,
              FontWeight.w800,
              slate800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Here is what LEAKLENS found in your water consumption pattern.',
            style: _text(
              14,
              FontWeight.w400,
              slate500,
            ),
          ),

          const SizedBox(height: 26),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: leakDetected
                    ? const Color(0xFFFECACA)
                    : const Color(0xFFBBF7D0),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  leakDetected
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: resultColor,
                  size: 52,
                ),
                const SizedBox(height: 12),
                Text(
                  leakDetected
                      ? 'Possible leak detected'
                      : 'No significant anomaly detected',
                  textAlign: TextAlign.center,
                  style: _text(
                    21,
                    FontWeight.w800,
                    resultColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Diagnostic confidence: $confidence%',
                  style: _text(
                    14,
                    FontWeight.w600,
                    slate500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _metricCard(
                  Icons.water_drop_outlined,
                  '${wasteLiters.toStringAsFixed(1)} L',
                  'Estimated waste/day',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  Icons.payments_outlined,
                  '${monthlyCost.toStringAsFixed(2)} DT',
                  'Estimated monthly cost',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (suspectedFixture.isNotEmpty)
            _infoCard(
              'Suspected fixture',
              suspectedFixture,
              Icons.home_repair_service_outlined,
            ),

          const SizedBox(height: 14),

          _infoCard(
            'Explanation',
            explanation,
            Icons.auto_awesome,
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == '/usage' || route.isFirst,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brand500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back to Start',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
          style: _text(
            18,
            FontWeight.w800,
            brand600,
          ),
        ),
      ],
    );
  }

  Widget _metricCard(
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: brand500,
            size: 23,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: _text(
              19,
              FontWeight.w800,
              slate800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: _text(
              11,
              FontWeight.w500,
              slate500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: brand600,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _text(
                    12,
                    FontWeight.w700,
                    brand600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: _text(
                    13,
                    FontWeight.w400,
                    const Color(0xFF0369A1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}