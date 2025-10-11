import 'package:flutter/material.dart';
import 'package:paynest_mobile/theme/app_theme.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  const GradientScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kGradient),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: child,
                ),
            ),
          ),
        ),
      ),
    );
  }
}
