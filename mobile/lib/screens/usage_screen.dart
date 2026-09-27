import 'package:flutter/material.dart';
import '../models/diagnostic_state.dart';
import 'fixtures_screen.dart';

class UsageScreen extends StatefulWidget {
  final DiagnosticState state;

  const UsageScreen({
    super.key,
    required this.state,
  });

  @override
  State<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  late double monthlyUsage;
  late List<String> selectedHours;

  final Color brand400 = const Color(0xFF38BDF8);
  final Color brand500 = const Color(0xFF0EA5E9);
  final Color brand600 = const Color(0xFF0284C7);

  @override
  void initState() {
    super.initState();

    monthlyUsage = widget.state.monthlyUsageM3;
    selectedHours = List<String>.from(widget.state.usageHours);
  }

  void selectTier(double value) {
    setState(() {
      monthlyUsage = value;
    });
  }

  void toggleHour(String hour) {
    setState(() {
      if (selectedHours.contains(hour)) {
        selectedHours.remove(hour);
      } else {
        selectedHours.add(hour);
      }
    });
  }

  void continueToFixtures() {
  widget.state.monthlyUsageM3 = monthlyUsage;
  widget.state.usageHours = List<String>.from(selectedHours);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FixturesScreen(
        diagnosticState: widget.state,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgress(),

                    const SizedBox(height: 24),

                    _buildTitle(),

                    const SizedBox(height: 24),

                    _buildMonthlyUsage(),

                    const SizedBox(height: 24),

                    _buildUsageHours(),

                    const SizedBox(height: 20),

                    _buildContinueButton(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE0F2FE),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back,
                size: 18,
                color: Color(0xFF475569),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildLogo(size: 20),

                    const SizedBox(width: 6),

                    Text(
                      'LEAKLENS',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: brand600,
                        height: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  "The water you can't see",
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: brand400,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  brand400,
                  brand500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x220EA5E9),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo({
    double size = 40,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WaveLogoPainter(
          color: brand500,
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STEP 1 OF 2',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Color(0xFF64748B),
                ),
              ),

              Text(
                '50% Completed',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: brand500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        brand400,
                        brand500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Water Usage',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Help LEAKLENS establish your baseline household consumption.',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyUsage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          Icons.water_drop,
          'Monthly Volume Range',
        ),

        const SizedBox(height: 12),

        _buildUsageTier(
          title: 'Low Usage',
          subtitle: '1 – 2 persons (~10 m³/month)',
          icon: Icons.person,
          value: 10,
        ),

        const SizedBox(height: 10),

        _buildUsageTier(
          title: 'Medium Usage',
          subtitle: 'Standard Family (~20 m³/month)',
          icon: Icons.group,
          value: 20,
        ),

        const SizedBox(height: 10),

        _buildUsageTier(
          title: 'High Usage',
          subtitle: 'House with Garden (~35+ m³/month)',
          icon: Icons.yard,
          value: 35,
        ),

        const SizedBox(height: 12),

        _buildSliderCard(),
      ],
    );
  }

  Widget _buildUsageTier({
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
  }) {
    final bool selected = monthlyUsage == value;

    return GestureDetector(
      onTap: () => selectTier(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0F9FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? brand400
                : const Color(0xFFE0F2FE),
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? brand400
                    : const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected
                    ? Colors.white
                    : brand500,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? brand500
                    : Colors.transparent,
                border: selected
                    ? null
                    : Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fine-tune estimate:',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: monthlyUsage.round().toString(),
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: brand500,
                      ),
                    ),
                    const TextSpan(
                      text: ' m³/mo',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0EA5E9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: brand500,
              inactiveTrackColor: const Color(0xFFE0F2FE),
              thumbColor: brand500,
              overlayColor: const Color(0x220EA5E9),
              trackHeight: 4,
            ),
            child: Slider(
              min: 5,
              max: 60,
              value: monthlyUsage.clamp(5, 60),
              onChanged: (value) {
                setState(() {
                  monthlyUsage = value.roundToDouble();
                });
              },
            ),
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5 m³',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                '30 m³',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                '60+ m³',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          Icons.schedule,
          'Usual Usage Hours',
        ),

        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.32,
          children: [
            _buildHourCard(
              hour: 'morning',
              title: 'Morning',
              subtitle: '06:00 – 09:00',
              icon: Icons.wb_twilight,
            ),
            _buildHourCard(
              hour: 'afternoon',
              title: 'Afternoon',
              subtitle: '12:00 – 14:00',
              icon: Icons.sunny,
            ),
            _buildHourCard(
              hour: 'evening',
              title: 'Evening',
              subtitle: '18:00 – 22:00',
              icon: Icons.nights_stay,
            ),
            _buildHourCard(
              hour: 'night',
              title: 'Night',
              subtitle: '23:00 – 05:00',
              icon: Icons.bedtime,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHourCard({
    required String hour,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool selected = selectedHours.contains(hour);

    return GestureDetector(
      onTap: () => toggleHour(hour),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0F9FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF7DD3FC)
                : const Color(0xFFE0F2FE),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? brand400
                        : const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF64748B),
                  ),
                ),

                Icon(
                  selected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: selected
                      ? brand500
                      : const Color(0xFFCBD5E1),
                ),
              ],
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: brand500,
          size: 18,
        ),

        const SizedBox(width: 6),

        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Arial',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: continueToFixtures,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              brand400,
              brand500,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330EA5E9),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Fixtures',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(width: 8),

            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveLogoPainter extends CustomPainter {
  final Color color;

  _WaveLogoPainter({
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scaleX = size.width / 48;
    final scaleY = size.height / 48;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    _drawWave(
      canvas,
      paint,
      16,
    );

    _drawWave(
      canvas,
      paint,
      24,
    );

    _drawWave(
      canvas,
      paint,
      32,
    );

    canvas.restore();
  }

  void _drawWave(
    Canvas canvas,
    Paint paint,
    double y,
  ) {
    final path = Path();

    path.moveTo(6, y);

    path.cubicTo(
      12,
      y - 4,
      18,
      y + 4,
      24,
      y,
    );

    path.cubicTo(
      30,
      y - 4,
      36,
      y + 4,
      42,
      y,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _WaveLogoPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}