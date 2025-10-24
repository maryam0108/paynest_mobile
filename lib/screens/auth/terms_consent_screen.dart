import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/screens/auth/welcome_screen.dart';

class TermsConsentScreen extends StatefulWidget {
  const TermsConsentScreen({super.key});

  @override
  State<TermsConsentScreen> createState() => _TermsConsentScreenState();
}

class _TermsConsentScreenState extends State<TermsConsentScreen> {
  bool _checked = false;

  void _agree() {
    if (!_checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm you’ve read and agree to continue')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  void _deny() async {
    // Offer a limited mode (no account linking) or exit/return.
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B2533),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Continue without consent?',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                'Without data consent, PayNest cannot read balances or transactions from linked accounts.\n'
                'You may continue in a *Limited Mode* (manual budgets only, no aggregation), or go back.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      secondary: true,
                      label: 'Go Back',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Use Limited Mode',
                      onPressed: () {
                        Navigator.pop(context); // close sheet
                        // Navigate to Welcome in limited mode (no linking)
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen(limitedMode: true)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Icon
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

            Text('Terms & Data Consent',
                style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
            Text(
              'Please review and accept to continue',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Terms card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _TermLine(
                    title: 'Account Linking & Data Use',
                    body:
                        'If you choose to link your bank or mobile money accounts, you authorize PayNest to retrieve limited financial data '
                        '(balances, transactions, statements) from those providers to display your unified balance, track expenses, and generate reports.',
                  ),
                  const SizedBox(height: 12),
                  _TermLine(
                    title: 'Purpose of Processing',
                    body:
                        'Your data is used strictly to power budgeting, spending analytics, payment history, and statements that you can export for your own use (e.g., bank applications).',
                  ),
                  const SizedBox(height: 12),
                  _TermLine(
                    title: 'Security & Consent',
                    body:
                        'We use biometric sign-in on your device for access. You can unlink accounts at any time. Without consent, aggregation features are disabled.',
                  ),
                  const SizedBox(height: 12),
                  _TermLine(
                    title: 'Your Control',
                    body:
                        'You may withdraw consent or request deletion of cached data from linked accounts. Limited Mode allows manual budgeting without aggregation.',
                  ),
                  const SizedBox(height: 12),
                  // _TermLine(
                  //   title: 'Demo Notice',
                  //   body:
                  //       'This is a prototype build for demonstration. Some integrations are simulated. No real banking PINs are collected by PayNest.',
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox confirm
            Row(
              children: [
                Checkbox(
                  value: _checked,
                  onChanged: (v) => setState(() => _checked = v ?? false),
                  activeColor: const Color(0xFF14B8A6),
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the Terms & Data Consent.',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Actions
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    secondary: true,
                    label: 'Deny',
                    onPressed: _deny,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Agree & Continue',
                    onPressed: _agree,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TermLine extends StatelessWidget {
  final String title;
  final String body;
  const _TermLine({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 18, color: Color(0xFF2DD4BF)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(body, style: GoogleFonts.inter(color: Colors.white70, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }
}