import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/wallet.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/app_input.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/pay/pay_success_page.dart';

class PayConfirmPage extends StatefulWidget {
  final List<WalletModel> wallets;
  final String initialMerchant;
  final double initialAmount;

  const PayConfirmPage({
    super.key,
    required this.wallets,
    required this.initialMerchant,
    required this.initialAmount,
  });

  @override
  State<PayConfirmPage> createState() => _PayConfirmPageState();
}

class _PayConfirmPageState extends State<PayConfirmPage> {
  final merchantCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  String? selectedWalletId;
  String method = 'fingerprint';
  bool confirming = false;

  @override
  void initState() {
    super.initState();
    merchantCtrl.text = widget.initialMerchant;
    amountCtrl.text = widget.initialAmount.toStringAsFixed(0);
    if (widget.wallets.isNotEmpty) {
      selectedWalletId = widget.wallets.first.id;
    }
  }

  @override
  void dispose() {
    merchantCtrl.dispose();
    amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() => confirming = true);
    await Future.delayed(const Duration(milliseconds: 700)); // simulate biometric
    final txnId = DateTime.now().millisecondsSinceEpoch.toString();
    final walletName = widget.wallets.firstWhere(
      (w) => w.id == selectedWalletId,
      orElse: () => WalletModel(id: 'unknown', name: 'Wallet', type: 'Wallet'),
    ).name;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaySuccessPage(
          txnId: txnId,
          merchant: merchantCtrl.text.trim().isEmpty ? 'Merchant' : merchantCtrl.text.trim(),
          amount: double.tryParse(amountCtrl.text.trim()) ?? 0,
          walletName: walletName,
          method: method,
        ),
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
            // Header row
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text('Confirm Payment',
                    style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Merchant
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Merchant', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  AppInput(controller: merchantCtrl, hint: 'e.g., Kahawa Cafe'),

                  const SizedBox(height: 12),
                  // Amount
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Amount (TSh)', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  AppInput(controller: amountCtrl, hint: '5000', type: TextInputType.number),

                  const SizedBox(height: 12),
                  // Wallet dropdown (only linked wallets)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Wallet', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.06),
                      border: Border.all(color: Colors.white.withOpacity(.12)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedWalletId,
                        dropdownColor: const Color(0xFF0B2533),
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more, color: Colors.white70),
                        items: widget.wallets.map((w) {
                          return DropdownMenuItem(
                            value: w.id,
                            child: Text('${w.name} • ${w.type}',
                                style: GoogleFonts.inter(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedWalletId = v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Biometric choice (simulated)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => method = 'fingerprint'),
                          icon: const Icon(Icons.fingerprint, color: Colors.white),
                          label: const Text('Fingerprint'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: method == 'fingerprint' ? const Color(0xFF2DD4BF) : Colors.white24,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => method = 'face'),
                          icon: const Icon(Icons.smartphone, color: Colors.white),
                          label: const Text('Face ID'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: method == 'face' ? const Color(0xFF2DD4BF) : Colors.white24,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  AppButton(
                    label: confirming ? 'Authorizing…' : 'Confirm & Pay',
                    onPressed: confirming ? null : _confirm,
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