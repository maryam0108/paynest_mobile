import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/models/wallet.dart';

class BankConsentPage extends StatefulWidget {
  final String bankId;
  final String bankName;
  const BankConsentPage({super.key, required this.bankId, required this.bankName});

  @override
  State<BankConsentPage> createState() => _BankConsentPageState();
}

class _BankConsentPageState extends State<BankConsentPage> {
  bool rBalance = true;
  bool rTxns = true;
  bool rPay = false;
  bool authorizing = false;

  String _mask(String input) {
    if (input.isEmpty) return '';
    if (input.length <= 4) return input;
    return '...${input.substring(input.length - 4)}';
  }

  Future<void> _authorize() async {
    setState(() => authorizing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    // Fake account metadata
    final acc = '00123456789';
    final masked = _mask(acc);
    final fakeBalance = 500000 + Random().nextInt(500000);

    final wallet = WalletModel(
      id: widget.bankId,
      name: widget.bankName,
      type: 'Bank',
      masked: masked,
      balance: fakeBalance.toDouble(),
    );

    if (!mounted) return;
    Navigator.pop(context); // close consent
    Navigator.pop(context); // close login
    Navigator.pop(context, wallet); // return to AddAccountPage with wallet
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
                Text('Authorize access',
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
                  _perm('View balances & account details', rBalance, (v) => setState(() => rBalance = v)),
                  _perm('View transaction history', rTxns, (v) => setState(() => rTxns = v)),
                  _perm('Initiate payments', rPay, (v) => setState(() => rPay = v)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: authorizing ? null : _authorize,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(authorizing ? 'Authorizing…' : 'Authorize'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can revoke access anytime in your bank settings.',
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

  Widget _perm(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: GoogleFonts.inter()),
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF2DD4BF),
    );
  }
}