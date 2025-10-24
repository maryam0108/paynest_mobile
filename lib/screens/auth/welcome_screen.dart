import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/app_input.dart';
import 'package:paynest_mobile/screens/auth/verify_biometric_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final bool limitedMode;
  const WelcomeScreen({super.key, this.limitedMode = false});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final nidaCtrl = TextEditingController();
  String method = 'fingerprint';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView( // 👈 helps on small screens/keyboard
        //padding: const EdgeInsets.fromLTRB(16, 1, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Logo + Title (unchanged)
            Row(
              children: [
                Hero(
                  tag: 'paynestLogo',
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6).withOpacity(.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(.35)),
                    ),
                    child: const Icon(Icons.fingerprint, color: Color(0xFF99F6E4)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PayNest', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
                    Text('Plan. Pay. Grow.', style: GoogleFonts.inter(color: Colors.white70)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔶 Limited Mode banner (responsive) — now ABOVE the heading
            if (widget.limitedMode)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.15),
                  border: Border.all(color: Colors.amber.withOpacity(.25)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amberAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded( // 👈 prevents horizontal overflow
                      child: Text(
                        'Limited Mode Active: Account linking is disabled. '
                        'You can still use manual budgeting and goals.',
                        style: GoogleFonts.inter(color: Colors.amberAccent, fontSize: 13.5, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

            // Heading
            Text('Welcome to PayNest', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
            Text(
              'Sign in with your NIDA and biometrics to unify your money — securely.',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // Form card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('NIDA Number', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  AppInput(controller: nidaCtrl, hint: 'e.g., 1999-01-23-12345'),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Fingerprint',
                          icon: Icons.fingerprint,
                          onPressed: () => setState(() => method = 'fingerprint'),
                          secondary: method != 'fingerprint',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Face ID',
                          icon: Icons.smartphone,
                          onPressed: () => setState(() => method = 'face'),
                          secondary: method != 'face',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Continue',
                    onPressed: () {
                      if (nidaCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a NIDA number')),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VerifyBiometricScreen(
                            nida: nidaCtrl.text.trim(),
                            method: method,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}