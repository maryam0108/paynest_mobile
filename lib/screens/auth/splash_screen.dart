import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/screens/auth/terms_consent_screen.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/auth/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = CurvedAnimation(parent: _ac, curve: Curves.easeOutBack); // zoom in w/ bounce
    _fade  = CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic);

    _ac.forward();
    // Give a moment after animation, then go to Welcome
    Timer(const Duration(milliseconds: 1400), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const TermsConsentScreen(), 
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HERO helps the logo glide into the WelcomeScreen header (optional)
                Hero(
                  tag: 'paynestLogo',
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6).withOpacity(.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(.35)),
                    ),
                    child: const Icon(Icons.fingerprint, color: Color(0xFF99F6E4), size: 36),
                  ),
                ),
                const SizedBox(height: 14),
                Text('PayNest', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700)),
                Text('Plan. Pay. Grow.', style: GoogleFonts.inter(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}