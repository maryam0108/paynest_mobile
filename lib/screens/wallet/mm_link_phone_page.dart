import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/models/wallet.dart';

class MobileMoneyLinkPhonePage extends StatefulWidget {
  final String providerId;
  final String providerName;

  const MobileMoneyLinkPhonePage({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  State<MobileMoneyLinkPhonePage> createState() => _MobileMoneyLinkPhonePageState();
}

class _MobileMoneyLinkPhonePageState extends State<MobileMoneyLinkPhonePage> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  bool sent = false;
  String sentCode = '';

  String _mask(String input) {
    if (input.isEmpty) return '';
    if (input.length <= 4) return input;
    return '...${input.substring(input.length - 4)}';
  }

  void _sendOtp() {
    // simulate sending 4-digit OTP
    sentCode = (1000 + Random().nextInt(8999)).toString();
    setState(() => sent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to ${phoneCtrl.text} (demo: $sentCode)')),
    );
  }

  void _verify() {
    if (otpCtrl.text.trim() != sentCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code')),
      );
      return;
    }
    final masked = _mask(phoneCtrl.text.trim());
    final w = WalletModel(
      id: widget.providerId,
      name: widget.providerName,
      type: 'Mobile Money',
      masked: masked,
      balance: 0,
    );
    Navigator.pop(context, w);
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
                Text('Link ${widget.providerName}', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
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
                  Align(alignment: Alignment.centerLeft, child: Text('Registered phone number', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'e.g., 07XXXXXXXX',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (!sent)
                    AppButton(label: 'Send OTP', onPressed: _sendOtp)
                  else ...[
                    Align(alignment: Alignment.centerLeft, child: Text('Enter OTP', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: otpCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: '4-digit code',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(label: 'Verify & Link', onPressed: _verify),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}