import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/wallet.dart';
import 'package:paynest_mobile/screens/wallet/add_account_page.dart';

class WalletPage extends StatelessWidget {
  final List<WalletModel> wallets;
  final void Function(WalletModel) onWalletAdded;

  const WalletPage({super.key, required this.wallets, required this.onWalletAdded});

  @override
  Widget build(BuildContext context) {
    final accountsToLink = [
      {'id': 'absa', 'name': 'Absa Tanzania', 'type': 'Bank'},
      {'id': 'airtel', 'name': 'Airtel Money', 'type': 'Mobile Money'},
      {'id': 'mpesa', 'name': 'M-Pesa', 'type': 'Mobile Money'},
      {'id': 'crdb', 'name': 'CRDB Bank', 'type': 'Bank'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Wallets', style: GoogleFonts.inter(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 8),

          // Horizontal sleek cards
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: wallets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final w = wallets[i];
                return _WalletCard(w: w);
              },
            ),
          ),

          const SizedBox(height: 18),
          Text('Link new accounts', style: GoogleFonts.inter(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 8),

          // Linkable list
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white.withOpacity(.1)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: accountsToLink.map((acc) {
                return ListTile(
                  leading: Icon(Icons.account_balance_wallet, color: Colors.white70),
                  title: Text(acc['name']!, style: GoogleFonts.inter(color: Colors.white)),
                  subtitle: Text(acc['type']!, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () async {
                      final result = await Navigator.of(context).push<WalletModel>(
                        MaterialPageRoute(
                          builder: (_) => AddAccountPage(
                            providerId: acc['id']!,
                            providerName: acc['name']!,
                            providerType: acc['type']!,
                          ),
                        ),
                      );
                      if (result != null) {
                        onWalletAdded(result);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${result.name} linked ✅')),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final WalletModel w;
  const _WalletCard({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF115E59), Color(0xFF0A1A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white24, width: .6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(w.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 4),
          Text(w.type, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
          const Spacer(),
          Text('Balance', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
          Text('TSh ${w.balance.toStringAsFixed(0)}', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20)),
          if (w.masked != null) Text(w.masked!, style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}