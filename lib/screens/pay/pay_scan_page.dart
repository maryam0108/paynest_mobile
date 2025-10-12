import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paynest_mobile/models/wallet.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/screens/pay/pay_confirm_page.dart';

class PayScanPage extends StatefulWidget {
  final List<WalletModel> wallets;
  const PayScanPage({super.key, required this.wallets});

  @override
  State<PayScanPage> createState() => _PayScanPageState();
}

class _PayScanPageState extends State<PayScanPage> {
  bool _navigated = false;

  void _goToConfirm({String? merchant, double? amount}) {
    if (_navigated) return;
    _navigated = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PayConfirmPage(
          wallets: widget.wallets,
          initialMerchant: merchant ?? 'Kahawa Cafe',
          initialAmount: amount ?? 5000,
        ),
      ),
    ).then((_) => _navigated = false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar-like row
            Row(
              children: [
                const Icon(Icons.qr_code_scanner, color: Colors.white70),
                const SizedBox(width: 8),
                Text('Scan to Pay',
                    style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            // Camera box
            Container(
              height: 320,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(.12)),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 8)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: MobileScanner(
                controller: MobileScannerController(
                  formats: [BarcodeFormat.qrCode],
                  detectionSpeed: DetectionSpeed.noDuplicates,
                ),
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final raw = barcode.rawValue ?? '';
                  // Try parse QR as JSON: {"merchant":"...", "amount":5000}
                  try {
                    final data = json.decode(raw);
                    _goToConfirm(
                      merchant: data['merchant']?.toString(),
                      amount: (data['amount'] is num) ? (data['amount'] as num).toDouble() : null,
                    );
                  } catch (_) {
                    // If not JSON, pass raw as merchant
                    if (raw.isNotEmpty) _goToConfirm(merchant: raw, amount: 5000);
                    else _goToConfirm();
                  }
                },
              ),
            ),

            const SizedBox(height: 14),
            Text(
              'Align the QR code within the frame to continue.',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
            const SizedBox(height: 18),

            // Prototype helper
            Center(
              child: AppButton(
                label: 'Simulate Scan',
                onPressed: () => _goToConfirm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}