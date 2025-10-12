import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/pay/receipt_page.dart';

class PaySuccessPage extends StatelessWidget {
  final String txnId;
  final String merchant;
  final double amount;
  final String walletName;
  final String method; // 'fingerprint' | 'face'

  const PaySuccessPage({
    super.key,
    required this.txnId,
    required this.merchant,
    required this.amount,
    required this.walletName,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Icon(Icons.check_circle, size: 88, color: Color(0xFF2DD4BF)),
            const SizedBox(height: 8),
            Text('Payment Successful', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('TSh ${amount.toStringAsFixed(0)} to $merchant', style: GoogleFonts.inter(color: Colors.white70)),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row('Transaction ID', txnId),
                  _row('Wallet', walletName),
                  _row('Method', method == 'fingerprint' ? 'Fingerprint' : 'Face ID'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'View Receipt',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReceiptPage(
                          txnId: txnId,
                          merchant: merchant,
                          amount: amount,
                          walletName: walletName,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Download Receipt',
                    onPressed: () {
                      // Prototype: simulate download
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Receipt saved (prototype)')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // --- NEW: A "Done" button to clearly signal the end of the flow ---
            AppButton(
              label: 'Done',
             
              onPressed: () {
                // Navigate back to the very first screen (usually the dashboard)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(k, style: GoogleFonts.inter(color: Colors.white70))),
          Text(v, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}