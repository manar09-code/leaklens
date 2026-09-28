import 'package:flutter/material.dart';
import 'diagnostic_screen.dart';\nimport 'settings_screen.dart';
import '../models/diagnostic_state.dart';

class FixturesScreen extends StatefulWidget {
  final DiagnosticState diagnosticState;

  const FixturesScreen({
    super.key,
    required this.diagnosticState,
  });

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  static const Color brand400 = Color(0xFF38BDF8);
  static const Color brand500 = Color(0xFF0EA5E9);
  static const Color brand600 = Color(0xFF0284C7);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate800 = Color(0xFF1E293B);

  late int fixtureCount;
  late String primaryFixture;

  final List<Map<String, dynamic>> fixtures = [
    {
      'name': 'Toilet',
      'icon': Icons.wc_outlined,
    },
    {
      'name': 'Shower',
      'icon': Icons.shower_outlined,
    },
    {
      'name': 'Kitchen',
      'icon': Icons.kitchen_outlined,
    },
    {
      'name': 'Laundry',
      'icon': Icons.local_laundry_service_outlined,
    },
    {
      'name': 'Garden',
      'icon': Icons.grass_outlined,
    },
    {
      'name': 'Pool',
      'icon': Icons.pool_outlined,
    },
    {
      'name': 'Other',
      'icon': Icons.water_drop_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();

    fixtureCount = widget.diagnosticState.fixtureCount;
    primaryFixture = widget.diagnosticState.primaryFixture;
  }

  TextStyle textStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = slate800,
  }) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  void continueToDiagnostic() {
  if (primaryFixture.isEmpty) {
    _showMessage(
      'Please select your primary water fixture.',
      error: true,
    );
    return;
  }

  widget.diagnosticState.fixtureCount = fixtureCount;
  widget.diagnosticState.primaryFixture = primaryFixture;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DiagnosticScreen(
        diagnosticState: widget.diagnosticState,
      ),
    ),
  );
}

  void _showMessage(
    String message, {
    bool success = false,
    bool error = false,
  }) {
    if (!mounted) return;

    final icon = success
        ? Icons.check_circle_outline
        : error
            ? Icons.error_outline
            : Icons.info_outline;

    final title = success
        ? 'Success'
        : error
            ? 'Something went wrong'
            : 'LEAKLENS';

    final accentColor = success
        ? const Color(0xFF16A34A)
        : error
            ? const Color(0xFFDC2626)
            : brand500;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          padding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE0F2FE),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A0F172A),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textStyle(
                          size: 13,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: textStyle(
                          size: 12,
                          color: slate500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 26),
              _buildProgress(),
              const SizedBox(height: 30),
              Text(
                'Your Water Fixtures',
                style: textStyle(
                  size: 28,
                  weight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell LEAKLENS about the water fixtures in your household.',
                style: textStyle(
                  size: 14,
                  color: slate500,
                ),
              ),
              const SizedBox(height: 28),
              _buildFixtureCount(),
              const SizedBox(height: 24),
              _buildPrimaryFixture(),
              const SizedBox(height: 30),
              _buildContinueButton(),
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
          IconButton(
            tooltip: 'Profile & Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    diagnosticState: widget.diagnosticState,
                  ),
                ),
              );
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
            const SizedBox(width: 8),
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
              style: textStyle(
                size: 18,
                weight: FontWeight.w800,
                color: brand600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '2 of 2',
              style: textStyle(
                size: 13,
                weight: FontWeight.w700,
                color: brand600,
              ),
            ),
            const Spacer(),
            Text(
              '100%',
              style: textStyle(
                size: 13,
                weight: FontWeight.w600,
                color: slate500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: 1,
            minHeight: 7,
            backgroundColor: const Color(0xFFBAE6FD),
            valueColor: const AlwaysStoppedAnimation<Color>(brand500),
          ),
        ),
      ],
    );
  }

  Widget _buildFixtureCount() {
    return Container(
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
          Text(
            'How many water fixtures do you have?',
            style: textStyle(
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Include toilets, showers, sinks, appliances, and other water points.',
            style: textStyle(
              size: 12,
              color: slate500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _counterButton(
                icon: Icons.remove,
                onTap: () {
                  if (fixtureCount > 1) {
                    setState(() {
                      fixtureCount--;
                    });
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$fixtureCount',
                    style: textStyle(
                      size: 30,
                      weight: FontWeight.w800,
                      color: brand600,
                    ),
                  ),
                ),
              ),
              _counterButton(
                icon: Icons.add,
                onTap: () {
                  if (fixtureCount < 20) {
                    setState(() {
                      fixtureCount++;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFBAE6FD),
            ),
          ),
          child: Icon(
            icon,
            color: brand600,
            size: 21,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryFixture() {
    return Container(
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
          Text(
            'What is your primary fixture?',
            style: textStyle(
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Choose the fixture most associated with your water usage.',
            style: textStyle(
              size: 12,
              color: slate500,
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fixtures.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final fixture = fixtures[index];
              final name = fixture['name'] as String;
              final icon = fixture['icon'] as IconData;
              final selected = primaryFixture == name.toLowerCase();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    primaryFixture = name.toLowerCase();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? brand400
                          : const Color(0xFFE2E8F0),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: selected ? brand600 : slate500,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: textStyle(
                            size: 12,
                            weight: selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: selected ? brand600 : slate800,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: brand500,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
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
          onPressed: continueToDiagnostic,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Continue',
            style: textStyle(
              size: 15,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
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

    Path createWave(double y) {
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

    canvas.drawPath(createWave(16), paint);
    canvas.drawPath(createWave(24), paint);
    canvas.drawPath(createWave(32), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}