import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/wallet/bank_consent_page.dart';

class BankLoginPage extends StatefulWidget {
  final String bankId;
  final String bankName;
  const BankLoginPage({super.key, required this.bankId, required this.bankName});

  @override
  State<BankLoginPage> createState() => _BankLoginPageState();
}

class _BankLoginPageState extends State<BankLoginPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _simulateLogin() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 1)); // fake network
    if (!mounted) return;
    setState(() => loading = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BankConsentPage(bankId: widget.bankId, bankName: widget.bankName),
      ),
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
            Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const SizedBox(width: 4),
                Text('${widget.bankName} — Secure Login',
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: userCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: loading ? null : _simulateLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(loading ? 'Signing in…' : 'Sign in'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This page is hosted by a trusted aggregator.\nYour credentials are not shared with PayNest.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
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