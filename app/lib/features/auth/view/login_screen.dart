import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.systemBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.52;
          
          return Column(
            children: [
              // Top Zone
              SizedBox(
                height: topHeight,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Yantra Background
                    Positioned.fill(
                      child: Opacity(
                        opacity: isDark ? 0.12 : 0.08,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCseNWVfjrCAN5YuM0K3VCges4u8kw8H07lVwa3gTI7M9Z3xeYh9ZQjIkKn28_oZTuTF2SoRTYdWEr3FwMVJdMMOJCc34xL4yHoqBDE0FAYdrCTOE0vRP4X_-F2gDjcd4gg9kcrD1tAfbqp-vwn2PJxL1Fb-Xm2q23rvNFGyMH40odpeMK3cEcYz7r-Zn7L0H6GFoRdwveOBaSsud3TxgflSHRqp3MNWilvUfAukt2tvJxMkDbp1I1G0gmSyte-hJb2dpdMO0EhtlQ',
                          fit: BoxFit.cover,
                          color: Colors.grey,
                          colorBlendMode: BlendMode.saturation,
                        ),
                      ),
                    ),
                    // Glow Effect
                    Container(
                      width: 240,
                      height: 240,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.saffronGlow,
                      ),
                    ),
                    // Om Symbol
                    Text(
                      'ॐ',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 56,
                        color: colors.saffron,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Zone
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    transform: Matrix4.translationValues(0.0, -32.0, 0.0),
                    decoration: BoxDecoration(
                      color: colors.secondarySystemBackground, // 1A1A1F in dark mode
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          // Decorative Gold Line
                          Container(
                            width: 32,
                            height: 2,
                            decoration: BoxDecoration(
                              color: colors.saffron.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Typography Section
                          Text(
                            'Begin your journey',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: colors.label,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to discover timeless wisdom',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.secondaryLabel,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          // Google Button Container
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: colors.tertiarySystemBackground, // surface-bright equivalent
                                side: BorderSide(
                                  color: colors.separator.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                foregroundColor: colors.label,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with Google',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colors.label,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 14,
                                color: colors.gold, 
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'GitaSarathi AI'.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  letterSpacing: 3,
                                  color: colors.label,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
