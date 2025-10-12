import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paynest_mobile/models/wallet.dart';
import 'package:paynest_mobile/models/transaction.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/widgets/app_button.dart';

class ReportsPage extends StatefulWidget {
  final List<WalletModel> wallets;
  final List<AppTransaction> transactions;

  const ReportsPage({
    super.key,
    required this.wallets,
    required this.transactions,
  });

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _fmtMoney = NumberFormat.decimalPattern(); // TSh grouping
  final _fmtDate = DateFormat('yyyy-MM-dd');

  String _range = 'Last 30 days';
  static const _ranges = ['Last 7 days', 'Last 30 days', 'Last 90 days', 'All time'];

  DateTime get _since {
    final now = DateTime.now();
    switch (_range) {
      case 'Last 7 days':
        return now.subtract(const Duration(days: 7));
      case 'Last 30 days':
        return now.subtract(const Duration(days: 30));
      case 'Last 90 days':
        return now.subtract(const Duration(days: 90));
      case 'All time':
        return DateTime.fromMicrosecondsSinceEpoch(0); // A very early date
      default:
        return now.subtract(const Duration(days: 30));
    }
  }

  // --- NEW HELPER FUNCTION ---
  // This function gets the wallet name. It first checks the real wallet list,
  // then falls back to dummy names for the prototype.
  String _getWalletName(String walletId) {
    // First, try to find the wallet in the list passed from the parent
    final wallet = widget.wallets.cast<WalletModel?>().firstWhere(
          (w) => w?.id == walletId,
          orElse: () => null,
        );
    if (wallet != null) {
      return wallet.name;
    }

    // If not found, fall back to hardcoded dummy names for the prototype
    switch (walletId) {
      case 'mpesa':
        return 'M-Pesa';
      case 'airtel':
        return 'Airtel Money';
      case 'nmb':
        return 'Absa Bank';
      case 'absa':
        return 'Absa Bank';
      default:
        return 'Unknown Wallet';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter transactions by the selected date range and sort them
    final tx = widget.transactions.where((t) => t.date.isAfter(_since)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return GradientScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Use Padding instead of SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Range Dropdown
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.white70),
                const SizedBox(width: 8),
                Text('Reports', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    border: Border.all(color: Colors.white.withOpacity(.12)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _range,
                      dropdownColor: const Color(0xFF0B2533),
                      items: _ranges
                          .map((r) => DropdownMenuItem(value: r, child: Text(r, style: GoogleFonts.inter(color: Colors.white))))
                          .toList(),
                      onChanged: (v) => setState(() => _range = v ?? _range),
                      icon: const Icon(Icons.expand_more, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transactions Header
            Row(
              children: [
                Text('All Transactions', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                const Spacer(),
                AppButton(
                  label: 'Export (PDF)',
                  onPressed: () {
                    // Prototype: simulate export
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Statement exported (prototype)')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Transactions List
            Expanded( // Use Expanded to make the list scrollable within the Column
              child: tx.isEmpty
                  ? Center(child: Text('No transactions in this period.', style: GoogleFonts.inter(color: Colors.white70)))
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.05),
                        border: Border.all(color: Colors.white.withOpacity(.1)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.builder(
                        itemCount: tx.length,
                        itemBuilder: (context, index) {
                          final t = tx[index];
                          // --- USE THE NEW HELPER FUNCTION HERE ---
                          final walletName = _getWalletName(t.walletId);
                          final isOut = t.amount < 0;
                          return ListTile(
                            dense: true,
                            leading: Icon(isOut ? Icons.arrow_upward : Icons.arrow_downward,
                                color: isOut ? const Color(0xFFEF4444) : const Color(0xFF22C55E)),
                            title: Text(t.merchant, style: GoogleFonts.inter()),
                            subtitle: Text(
                              '${_fmtDate.format(t.date)} • ${t.category} • $walletName',
                              style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                            ),
                            trailing: Text(
                              (isOut ? '-' : '+') + 'TSh ${_fmtMoney.format(t.amount.abs())}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: isOut ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
             const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

