import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'models/diagnostic_state.dart';
import 'screens/usage_screen.dart';

void main() {
  runApp(const LeakLensApp());
}

class LeakLensApp extends StatelessWidget {
  const LeakLensApp({super.key});

  static const brand500 = Color(0xFF0EA5E9);
  static const brand600 = Color(0xFF0284C7);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEAKLENS',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: brand500,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? registeredEmail;
  String? registeredPassword;

  static const brand500 = Color(0xFF0EA5E9);
  static const brand600 = Color(0xFF0284C7);
  static const sky200 = Color(0xFFBAE6FD);
  static const slate800 = Color(0xFF1E293B);
  static const slate500 = Color(0xFF64748B);

  TextStyle textStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = slate800,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          : const Color(0xFF0EA5E9);

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
                        color: slate800,
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

  void _handleAuth() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'Please enter your email and password.',
        error: true,
    );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must contain at least 6 characters.');
      return;
    }

    if (!isLogin) {
      registeredEmail = email;
      registeredPassword = password;

      setState(() {
        isLogin = true;
        passwordController.clear();
      });

      _showMessage(
        'Account created successfully. You can now log in.',
      );

      return;
    }

    if (registeredEmail == null || registeredPassword == null) {
      _showMessage(
        'No account found. Please create an account first.',
      );
      return;
    }

    if (email != registeredEmail || password != registeredPassword) {
      _showMessage(
        'Incorrect email or password.',
      );
      return;
    }

    final state = DiagnosticState();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsageScreen(
          state: state,
        ),
      ),
    );
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(
          registeredEmail: registeredEmail,
          onPasswordReset: (email, newPassword) {
            registeredEmail = email;
            registeredPassword = newPassword;
          },
        ),
      ),
    );
  }

  void _showSocialUnavailable(String provider) {
    _showMessage(
      '$provider sign-in is not available in this MVP.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F9FF),
              Colors.white,
              Color(0xFFF0F9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      _buildBranding(),
                      const SizedBox(height: 24),
                      _buildAuthTabs(),
                      const SizedBox(height: 24),
                      _buildAuthCard(),
                      const SizedBox(height: 24),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.string(
              '''
<svg viewBox="0 0 48 48"
     fill="none"
     xmlns="http://www.w3.org/2000/svg">
  <path
    d="M6 16C12 12 18 20 24 16C30 12 36 20 42 16"
    stroke="#0EA5E9"
    stroke-width="4.5"
    stroke-linecap="round"
    stroke-linejoin="round"/>
  <path
    d="M6 24C12 20 18 28 24 24C30 20 36 28 42 24"
    stroke="#0EA5E9"
    stroke-width="4.5"
    stroke-linecap="round"
    stroke-linejoin="round"/>
  <path
    d="M6 32C12 28 18 36 24 32C30 28 36 36 42 32"
    stroke="#0EA5E9"
    stroke-width="4.5"
    stroke-linecap="round"
    stroke-linejoin="round"/>
</svg>
              ''',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12),
            Text(
              'LEAKLENS',
              style: textStyle(
                size: 26,
                weight: FontWeight.w800,
                color: brand600,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "THE WATER YOU CAN'T SEE",
          style: textStyle(
            size: 12,
            weight: FontWeight.w600,
            color: brand500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xB3E0F2FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = true;
                  passwordController.clear();
                });
              },
              child: _tab(
                icon: Icons.login,
                label: 'Log In',
                active: isLogin,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = false;
                  passwordController.clear();
                });
              },
              child: _tab(
                icon: Icons.person_add_outlined,
                label: 'Sign Up',
                active: !isLogin,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: active ? brand600 : slate500,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: textStyle(
              size: 14,
              weight: active ? FontWeight.w700 : FontWeight.w600,
              color: active ? brand600 : slate500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0F2FE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260EA5E9),
            blurRadius: 30,
            spreadRadius: -5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLogin ? 'Welcome back' : 'Create your account',
            style: textStyle(
              size: 18,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isLogin
                ? 'Enter your credentials to monitor your smart water flow.'
                : 'Create an account to start monitoring your smart water flow.',
            style: textStyle(
              size: 12,
              color: slate500,
            ),
          ),
          const SizedBox(height: 24),

          _buildLabel(
            icon: Icons.mail_outline,
            text: 'EMAIL ADDRESS',
          ),
          const SizedBox(height: 6),

          _buildTextField(
            controller: emailController,
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel(
                icon: Icons.lock_outline,
                text: 'PASSWORD',
              ),
              if (isLogin)
                GestureDetector(
                  onTap: _openForgotPassword,
                  child: Text(
                    'Forgot?',
                    style: textStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: brand500,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: textStyle(size: 14),
            decoration: InputDecoration(
              hintText: '••••••••••••',
              filled: true,
              fillColor: const Color(0x80F0F9FF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: sky200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: sky200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: brand500,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildLoginButton(),

          const SizedBox(height: 24),

          _buildDivider(),

          const SizedBox(height: 24),

          _buildSocialButtons(),
        ],
      ),
    );
  }

  Widget _buildLabel({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: brand500,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: textStyle(
            size: 12,
            weight: FontWeight.w700,
            color: const Color(0xFF475569),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: textStyle(size: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0x80F0F9FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sky200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sky200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: brand500,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF38BDF8),
            Color(0xFF0EA5E9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D38BDF8),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _handleAuth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? 'Log In' : 'Create Account',
                  style: textStyle(
                    size: 14,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFE2E8F0)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or continue with',
            style: textStyle(
              size: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFE2E8F0)),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _socialButton(
            icon: const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: Color(0xFF4285F4),
            ),
            label: 'Google',
            onTap: () => _showSocialUnavailable('Google'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _socialButton(
            icon: const Icon(
              Icons.apple,
              size: 20,
              color: Color(0xFF1E293B),
            ),
            label: 'Apple',
            onTap: () => _showSocialUnavailable('Apple'),
          ),
        ),
      ],
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(color: sky200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                label,
                style: textStyle(
                  size: 12,
                  weight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLogin = !isLogin;
          passwordController.clear();
        });
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: textStyle(
            size: 12,
            color: slate500,
          ),
          children: [
            TextSpan(
              text: isLogin
                  ? 'New to LEAKLENS? '
                  : 'Already have an account? ',
            ),
            TextSpan(
              text: isLogin
                  ? 'Create an account'
                  : 'Log in',
              style: textStyle(
                size: 12,
                weight: FontWeight.w700,
                color: brand500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  final String? registeredEmail;
  final void Function(String email, String newPassword) onPasswordReset;

  const ForgotPasswordScreen({
    super.key,
    required this.registeredEmail,
    required this.onPasswordReset,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const brand500 = Color(0xFF0EA5E9);
  static const sky200 = Color(0xFFBAE6FD);
  static const slate800 = Color(0xFF1E293B);
  static const slate500 = Color(0xFF64748B);

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmation = confirmPasswordController.text;

    if (widget.registeredEmail == null) {
      _showMessage('No account exists yet. Please create one first.');
      return;
    }

    if (email != widget.registeredEmail) {
      _showMessage('No account was found with this email.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must contain at least 6 characters.');
      return;
    }

    if (password != confirmation) {
      _showMessage('Passwords do not match.');
      return;
    }

    widget.onPasswordReset(email, password);

    _showMessage(
      'Your password has been updated successfully.',
      success: true,
    );

    Navigator.pop(context);
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
          : const Color(0xFF0EA5E9);

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
                        color: slate800,
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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: suffixIcon != null,
      style: textStyle(size: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0x80F0F9FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sky200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sky200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: brand500,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: textStyle(
        size: 12,
        weight: FontWeight.w700,
        color: const Color(0xFF475569),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: slate800,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Forgot Password',
          style: textStyle(
            size: 18,
            weight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F9FF),
              Colors.white,
              Color(0xFFF0F9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE0F2FE),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x260EA5E9),
                        blurRadius: 30,
                        spreadRadius: -5,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.string(
                          '''
<svg viewBox="0 0 48 48"
     fill="none"
     xmlns="http://www.w3.org/2000/svg">
  <path d="M6 16C12 12 18 20 24 16C30 12 36 20 42 16"
    stroke="#0EA5E9" stroke-width="4.5"
    stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M6 24C12 20 18 28 24 24C30 20 36 28 42 24"
    stroke="#0EA5E9" stroke-width="4.5"
    stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M6 32C12 28 18 36 24 32C30 28 36 36 42 32"
    stroke="#0EA5E9" stroke-width="4.5"
    stroke-linecap="round" stroke-linejoin="round"/>
</svg>
                          ''',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Reset your password',
                          style: textStyle(
                            size: 20,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Enter your registered email and choose a new password.',
                          textAlign: TextAlign.center,
                          style: textStyle(
                            size: 12,
                            color: slate500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      _label('EMAIL ADDRESS'),
                      const SizedBox(height: 6),
                      _field(
                        controller: emailController,
                        hint: 'name@example.com',
                      ),

                      const SizedBox(height: 18),

                      _label('NEW PASSWORD'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: textStyle(size: 14),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          filled: true,
                          fillColor: const Color(0x80F0F9FF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: sky200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: sky200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: brand500,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _label('CONFIRM PASSWORD'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        style: textStyle(size: 14),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          filled: true,
                          fillColor: const Color(0x80F0F9FF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: sky200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: sky200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: brand500,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF38BDF8),
                              Color(0xFF0EA5E9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _resetPassword,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Reset Password',
                                    style: textStyle(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Back to Log In',
                            style: textStyle(
                              size: 12,
                              weight: FontWeight.w700,
                              color: brand500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}