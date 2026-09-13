import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'kai_welcome_screen.dart';
import '../services/auth_service.dart';

/// Sign Up & Login Screen with social buttons, email inputs, and Kai mascot peeking header.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final displayName = _nameController.text.trim();

    if ((!_isLoginMode && displayName.isEmpty) || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLoginMode
                ? 'Please enter your email and password.'
                : 'Please enter your name, email, and password.',
          ),
        ),
      );
      return;
    }

    try {
      if (_isLoginMode) {
        // LOGIN
        final response = await AuthService.signIn(
          email: email,
          password: password,
        );

        if (response.user != null) {
          if (displayName.isNotEmpty) {
            try {
              await AuthService.updateDisplayName(displayName);
            } catch (_) {
              // Profile persistence must not prevent a valid login.
            }
          }
          HapticFeedback.mediumImpact();

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const KaiWelcomeScreen()),
          );
        }
      } else {
        // SIGN UP
        final response = await AuthService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );

        if (response.user != null) {
          HapticFeedback.mediumImpact();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );

          setState(() {
            _isLoginMode = true;
          });
        }
      }
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Peeking Kai Mascot Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      KaiMascot(size: 60, expression: KaiExpression.happy),
                      SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(
                          text:
                              "Let's get you in — I promise this is the boring part 😴",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Auth Card Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: const Color(0xFF161426).withValues(alpha: 0.8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLoginMode
                                  ? 'Welcome Back!'
                                  : 'Create Your Account',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isLoginMode
                                  ? 'Log in to continue your weekend planning journey.'
                                  : 'Sign up to start planning your perfect weekend with me!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Google Button
                            _SocialAuthButton(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Continue with Google',
                              onTap: _handleEmailAuth,
                            ),

                            const SizedBox(height: 10),

                            // Apple Button
                            _SocialAuthButton(
                              icon: Icons.apple_rounded,
                              label: 'Continue with Apple',
                              onTap: _handleEmailAuth,
                            ),

                            const SizedBox(height: 20),

                            // OR Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Name Field
                            _AuthTextField(
                              controller: _nameController,
                              hintText: _isLoginMode
                                  ? 'Your name (optional)'
                                  : 'Your name',
                              icon: Icons.person_rounded,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 12),

                            _AuthTextField(
                              controller: _emailController,
                              hintText: 'alex@example.com',
                              icon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 12),

                            // Password Field
                            _AuthTextField(
                              controller: _passwordController,
                              hintText: '••••••••••••',
                              icon: Icons.lock_rounded,
                              obscureText: true,
                            ),

                            const SizedBox(height: 24),

                            // Continue Button
                            ElevatedButton(
                              onPressed: _handleEmailAuth,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF7A59),
                                      Color(0xFF8B5CF6),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x60FF7A59),
                                      blurRadius: 16,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _isLoginMode
                                        ? 'Log In ➔'
                                        : 'Create Account ➔',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom Log In Link
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        text: _isLoginMode
                            ? 'Don\'t have an account? '
                            : 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13.5,
                        ),
                        children: [
                          TextSpan(
                            text: _isLoginMode ? 'Sign up' : 'Log in',
                            style: const TextStyle(
                              color: Color(0xFFFF7A59),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialAuthButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.6),
          size: 20,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF2DD4BF), width: 1.8),
        ),
      ),
    );
  }
}
