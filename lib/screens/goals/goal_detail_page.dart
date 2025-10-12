import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/goal.dart';
import 'package:paynest_mobile/models/wallet.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';

class GoalDetailPage extends StatelessWidget {
  final GoalModel goal;
  const GoalDetailPage({super.key, required this.goal});

  String _fmt(double v) => v.toStringAsFixed(0);

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
                Text('Goal Details', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            // Progress card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 100, height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: goal.progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withOpacity(.15),
                          color: const Color(0xFF14B8A6),
                        ),
                        Center(
                          child: Text('${(goal.progress * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text('Saved: TSh ${_fmt(goal.current)} / ${_fmt(goal.target)}', style: GoogleFonts.inter(color: Colors.white70)),
                        Text('Duration: ${goal.durationLabel}', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                        Text('Frequency: ${goal.frequency}', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Add Money',
                    onPressed: () async {
                      final updated = await showDialog<GoalModel>(
                        context: context,
                        builder: (_) => _MoneyDialog(goal: goal, type: _MoneyAction.add),
                      );
                      if (updated != null && context.mounted) Navigator.pop(context, updated);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Withdraw',
                    onPressed: () async {
                      final updated = await showDialog<GoalModel>(
                        context: context,
                        builder: (_) => _MoneyDialog(goal: goal, type: _MoneyAction.withdraw),
                      );
                      if (updated != null && context.mounted) Navigator.pop(context, updated);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _MoneyAction { add, withdraw }

class _MoneyDialog extends StatefulWidget {
  final GoalModel goal;
  final _MoneyAction type;
  const _MoneyDialog({required this.goal, required this.type});

  @override
  State<_MoneyDialog> createState() => _MoneyDialogState();
}

class _MoneyDialogState extends State<_MoneyDialog> {
  final amtCtrl = TextEditingController();
  String? walletId;

  @override
  Widget build(BuildContext context) {
    // Pull wallets passed through the tree if needed; for prototype we’ll read from a simple Inherited widget
    // To keep this file standalone, we’ll get wallets from ModalRoute arguments if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    final wallets = (args is List<WalletModel>) ? args : <WalletModel>[];

    return AlertDialog(
      backgroundColor: const Color(0xFF0B2533),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.type == _MoneyAction.add ? 'Add Money' : 'Withdraw Money',
        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amtCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Amount (TSh)',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: walletId,
                dropdownColor: const Color(0xFF0B2533),
                isExpanded: true,
                icon: const Icon(Icons.expand_more, color: Colors.white70),
                items: wallets.map((w) {
                  return DropdownMenuItem(
                    value: w.id,
                    child: Text('${w.name} • ${w.type}', style: GoogleFonts.inter(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => walletId = v),
                hint: Text('Select wallet', style: GoogleFonts.inter(color: Colors.white54)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final amt = double.tryParse(amtCtrl.text.trim()) ?? 0;
            if (amt <= 0) return;
            double next = widget.goal.current;
            if (widget.type == _MoneyAction.add) next += amt;
            if (widget.type == _MoneyAction.withdraw) next = (next - amt).clamp(0, widget.goal.target);
            final updated = widget.goal.copyWith(current: next);
            Navigator.pop(context, updated);
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF14B8A6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}