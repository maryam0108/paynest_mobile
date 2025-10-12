import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/app_input.dart';
import 'package:paynest_mobile/screens/auth/verify_biometric_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final nidaCtrl = TextEditingController();
  String method = 'fingerprint';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + title
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withOpacity(.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(.35)),
                ),
                child: const Icon(Icons.fingerprint, color: Color(0xFF99F6E4)),
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
          const SizedBox(height: 18),
          Text('Welcome to PayNest', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
          Text('Sign in with your NIDA and biometrics to unify your money — securely.',
              style: GoogleFonts.inter(color: Colors.white70)),
          const SizedBox(height: 28),

          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white.withOpacity(.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft,
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
                      ScaffoldMessenger.of(context).
                      showSnackBar(
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

          const SizedBox(height: 12),
      
        ],
     ),
);
}
}


