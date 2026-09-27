import 'package:flutter/material.dart';

import '../models/diagnostic_state.dart';
import 'results_screen.dart';

class DiagnosticScreen extends StatefulWidget {
  final DiagnosticState diagnosticState;

  const DiagnosticScreen({
    super.key,
    required this.diagnosticState,
  });

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  static const Color brand400 = Color(0xFF38BDF8);
  static const Color brand500 = Color(0xFF0EA5E9);
  static const Color brand600 = Color(0xFF0284C7);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);

  bool analyzing = false;

  void _startDiagnostic() async {
    setState(() {
      analyzing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      analyzing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          diagnosticState: widget.diagnosticState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.diagnosticState;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),

              Text(
                'Ready for your diagnostic?',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: slate800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'LEAKLENS will analyze your usage pattern and look for unusual water consumption.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: slate500,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 28),

              _buildSummaryCard(state),

              const SizedBox(height: 24),

              _buildInfoCard(),

              const SizedBox(height: 30),

              _buildAnalyzeButton(),
            ],
          ),
        ),
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
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CustomPaint(
                painter: _WaveLogoPainter(),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'LEAKLENS',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: brand600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(DiagnosticState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR INPUT',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: slate500,
            ),
          ),
          const SizedBox(height: 16),

          _summaryRow(
            Icons.water_drop_outlined,
            'Monthly usage',
            '${state.monthlyUsageM3.round()} m³',
          ),

          _summaryRow(
            Icons.schedule,
            'Usage hours',
            state.usageHours.join(', '),
          ),

          _summaryRow(
            Icons.water_damage_outlined,
            'Water fixtures',
            '${state.fixtureCount}',
          ),

          _summaryRow(
            Icons.home_repair_service_outlined,
            'Primary fixture',
            state.primaryFixture.isEmpty
                ? 'Not selected'
                : state.primaryFixture,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: brand500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 13,
                color: slate500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: slate800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome,
            color: Color(0xFF0284C7),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'LEAKLENS checks your consumption level, usage timing, and fixture pattern to identify possible anomalies.',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 12,
                height: 1.45,
                color: Color(0xFF0369A1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              brand400,
              brand500,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330EA5E9),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: analyzing ? null : _startDiagnostic,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: analyzing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Run Diagnostic',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _WaveLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0EA5E9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scaleX = size.width / 48;
    final scaleY = size.height / 48;

    Path wave(double y) {
      final path = Path();

      path.moveTo(6 * scaleX, y * scaleY);

      path.cubicTo(
        12 * scaleX,
        (y - 4) * scaleY,
        18 * scaleX,
        (y + 4) * scaleY,
        24 * scaleX,
        y * scaleY,
      );

      path.cubicTo(
        30 * scaleX,
        (y - 4) * scaleY,
        36 * scaleX,
        (y + 4) * scaleY,
        42 * scaleX,
        y * scaleY,
      );

      return path;
    }

    canvas.drawPath(wave(16), paint);
    canvas.drawPath(wave(24), paint);
    canvas.drawPath(wave(32), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}