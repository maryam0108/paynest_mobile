import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/screens/auth/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text('Welcome, you are now logged in ✅',
              style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(
            'This is a placeholder dashboard — plug in budgeting, QR pay, and reports here.',
            style: GoogleFonts.inter(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Log out',
            secondary: true,
            icon: Icons.logout,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (_) => false,
            ),
          ),
        ],
     ),
);
}
}
