import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/wallet/bank_connect_intro_page.dart';
import 'package:paynest_mobile/screens/wallet/mm_link_phone_page.dart';
import 'package:paynest_mobile/models/wallet.dart';

class AddAccountPage extends StatelessWidget {
  final String providerId;
  final String providerName;
  final String providerType; // 'Bank' | 'Mobile Money'

  const AddAccountPage({
    super.key,
    required this.providerId,
    required this.providerName,
    required this.providerType,
  });

  @override
  Widget build(BuildContext context) {
    final isBank = providerType.toLowerCase().contains('bank');

    return GradientScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Text('Link $providerName',
                  style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(providerType, style: GoogleFonts.inter(color: Colors.white70)),
          const SizedBox(height: 18),

          // Explain secure hand-off for banks; phone+OTP for MNOs.
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white.withOpacity(.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              isBank
                  ? 'For your security, PayNest never asks for your bank PIN.\nYou’ll authenticate on the bank’s secure page and grant limited permissions.'
                  : 'Link your mobile wallet with your registered phone number.\nWe’ll verify using a one-time code (OTP).',
              style: GoogleFonts.inter(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () async {
                if (isBank) {
                  final res = await Navigator.of(context).push<WalletModel>(
                    MaterialPageRoute(
                      builder: (_) => BankConnectIntroPage(
                        bankId: providerId,
                        bankName: providerName,
                      ),
                    ),
                  );
                  if (res != null && context.mounted) Navigator.pop(context, res);
                } else {
                  final res = await Navigator.of(context).push<WalletModel>(
                    MaterialPageRoute(
                      builder: (_) => MobileMoneyLinkPhonePage(
                        providerId: providerId,
                        providerName: providerName,
                      ),
                    ),
                  );
                  if (res != null && context.mounted) Navigator.pop(context, res);
                }
              },
              icon: const Icon(Icons.link),
              label: Text(isBank ? 'Continue to secure bank login' : 'Continue to phone verification'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}