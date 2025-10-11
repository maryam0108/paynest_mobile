import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/screens/home/home_shell.dart';

class VerifyBiometricScreen extends StatefulWidget {
  final String nida;
  final String method; // 'fingerprint' or 'face'

  const VerifyBiometricScreen({
    super.key,
    required this.nida,
    required this.method,
  });

  @override
  State<VerifyBiometricScreen> createState() => _VerifyBiometricScreenState();
}

class _VerifyBiometricScreenState extends State<VerifyBiometricScreen> {
  bool registered = false;
  bool checking = false;

  // ✅ Fake registration for prototype (no plugins, no errors)
  Future<void> _doRegister() async {
    setState(() => checking = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => registered = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful ✅')),
    );
    setState(() => checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
          Text('Secure your account', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
          Text('NIDA: ${widget.nida}\nMethod: ${widget.method == 'fingerprint' ? 'Fingerprint' : 'Face ID'}',
              style: GoogleFonts.inter(color: Colors.white70)),
          const SizedBox(height: 18),

          // Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white.withOpacity(.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(widget.method == 'fingerprint' ? Icons.fingerprint : Icons.smartphone,
                    size: 68, color: const Color(0xFF99F6E4)),
                const SizedBox(height: 12),
                Text(
                  'Place your ${widget.method == 'fingerprint' ? 'finger on the sensor' : 'face within the frame'}',
                  style: GoogleFonts.inter(color: Colors.white70),
                ),
                const SizedBox(height: 18),

                // ✅ Now just simulates + SnackBar
                AppButton(
                  label: checking ? 'Authorizing…' : 'Verify now',
                  icon: Icons.verified_user,
                  onPressed: checking ? null : _doRegister,
                ),
                const SizedBox(height: 10),

                // ✅ After “registration” show Login button
                if (registered)
                  AppButton(
                    label: 'Login to PayNest',
                    icon: Icons.login,
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}