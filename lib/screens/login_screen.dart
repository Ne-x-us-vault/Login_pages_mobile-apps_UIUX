import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_blobs.dart';
import '../widgets/floating_emojis.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/avatar_ring.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _isLogin = true;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _agreeTerms = false;
  bool _isSubmitting = false;

  final List<String> _avatars = ['😊', '😍', '😉', '🤩', '😌'];
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
    ));

    _startAvatarRotation();
  }

  void _startAvatarRotation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _avatarIndex = (_avatarIndex + 1) % _avatars.length;
        });
        _startAvatarRotation();
      }
    });
  }

  void _toggleCard() {
    setState(() => _isLogin = !_isLogin);
    if (_isLogin) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBlobs(),
          const FloatingEmojis(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value;
                  final isFront = angle < pi / 2;

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: isFront ? _buildLoginCard() : _buildSignupCard(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return _GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarRing(emoji: _avatars[_avatarIndex]),
          const SizedBox(height: 12),
          const Text(
            'Welcome back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'So glad to see you again 💖',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 28),
          CustomTextField(
            label: 'Email',
            hint: 'hello@you.com',
            icon: Icons.email_outlined,
            controller: _loginEmailController,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 18),
          CustomTextField(
            label: 'Password',
            hint: 'your secret',
            icon: Icons.lock_outline,
            isPassword: true,
            controller: _loginPasswordController,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCheckbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                label: 'Remember me',
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot?',
                  style: TextStyle(
                    color: AppColors.pinkDeep,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Let me in!',
            isLoading: _isSubmitting,
            onPressed: _handleLogin,
          ),
          const SizedBox(height: 22),
          _buildDivider('or continue with'),
          const SizedBox(height: 16),
          const Row(
            children: [
              SocialButton(
                text: 'Google',
                icon: Icons.g_mobiledata_rounded,
              ),
              SizedBox(width: 12),
              SocialButton(
                text: 'Apple',
                icon: Icons.apple_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New here? ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight.withValues(alpha: 0.8),
                ),
              ),
              GestureDetector(
                onTap: _toggleCard,
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    color: AppColors.pinkDeep,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignupCard() {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: _GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AvatarRing(emoji: '🧐'),
            const SizedBox(height: 12),
            const Text(
              'Create account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's get you started 🌟",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 28),
            CustomTextField(
              label: 'Full name',
              hint: 'Your name',
              icon: Icons.person_outline,
              controller: _signupNameController,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            CustomTextField(
              label: 'Email',
              hint: 'hello@you.com',
              icon: Icons.email_outlined,
              controller: _signupEmailController,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            CustomTextField(
              label: 'Password',
              hint: 'make it strong!',
              icon: Icons.lock_open_outlined,
              isPassword: true,
              controller: _signupPasswordController,
              validator: (v) =>
                  (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 20),
            CustomCheckbox(
              value: _agreeTerms,
              onChanged: (v) => setState(() => _agreeTerms = v ?? false),
              label: 'I agree to the terms',
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Create my account',
              isLoading: _isSubmitting,
              onPressed: _handleSignup,
            ),
            const SizedBox(height: 22),
            _buildDivider('or sign up with'),
            const SizedBox(height: 16),
            const Row(
              children: [
                SocialButton(
                  text: 'Google',
                  icon: Icons.g_mobiledata_rounded,
                ),
                SizedBox(width: 12),
                SocialButton(
                  text: 'Apple',
                  icon: Icons.apple_rounded,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have one? ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight.withValues(alpha: 0.8),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleCard,
                  child: const Text(
                    'Log in instead',
                    style: TextStyle(
                      color: AppColors.pinkDeep,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.lavender.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.lavender.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Welcome!'),
          backgroundColor: AppColors.mint,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }

  void _handleSignup() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✨ You're in!"),
          backgroundColor: AppColors.mint,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.92,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 44),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 40,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: child,
        ),
      ),
    );
  }
}
