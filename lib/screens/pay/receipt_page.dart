import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';

class ReceiptPage extends StatelessWidget {
  final String txnId;
  final String merchant;
  final double amount;
  final String walletName;

  const ReceiptPage({
    super.key,
    required this.txnId,
    required this.merchant,
    required this.amount,
    required this.walletName,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const SizedBox(width: 4),
                Text('Payment Receipt', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black87),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line('Merchant', merchant),
                    _line('Amount', 'TSh ${amount.toStringAsFixed(0)}'),
                    _line('Wallet', walletName),
                    _line('Transaction ID', txnId),
                    const Divider(),
                    Center(child: Text('Thanks for using PayNest', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text('Tip: Use your phone’s Share/Print to export this receipt as PDF.',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _line(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(v),
        ],
      ),
    );
  }
}