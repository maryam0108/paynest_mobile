import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/budget.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';

class BudgetDetailPage extends StatelessWidget {
  final BudgetModel budget;
  const BudgetDetailPage({super.key, required this.budget});

  String _fmt(double v) => v.toStringAsFixed(0);

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row (consistent with CreateBudgetPage)
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Back',
                ),
                const SizedBox(width: 4),
                Text('Budget Details',
                    style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),

            // Overall usage card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Usage', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: budget.progress.toDouble(), // ensure double
                      minHeight: 12,
                      backgroundColor: Colors.white.withOpacity(.15),
                      color: const Color(0xFF14B8A6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Spent TSh ${_fmt(budget.totalSpent)} / TSh ${_fmt(budget.total)}',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Summary chips (sleek quick stats)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatChip(
                  label: 'Total',
                  value: 'TSh ${_fmt(budget.total)}',
                  icon: Icons.account_balance_wallet,
                ),
                _StatChip(
                  label: 'Allocated',
                  value: 'TSh ${_fmt(budget.totalAllocated)}',
                  icon: Icons.pie_chart,
                ),
                _StatChip(
                  label: 'Duration',
                  value: budget.durationLabel,
                  icon: Icons.calendar_month,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Categories list (modern cards)
            Text('Categories', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Column(
              children: budget.categories.map((c) {
                final cap = c.allocation == 0
                    ? 0.0
                    : (c.spent / c.allocation).clamp(0, 1).toDouble();
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    border: Border.all(color: Colors.white.withOpacity(.1)),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row
                      Row(
                        children: [
                          Expanded(
                            child: Text(c.name,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.06),
                              border: Border.all(color: Colors.white.withOpacity(.1)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'TSh ${_fmt(c.allocation)}',
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Progress
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: cap,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(.12),
                          color: const Color(0xFF14B8A6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Spent TSh ${_fmt(c.spent)} / TSh ${_fmt(c.allocation)}',
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        border: Border.all(color: Colors.white.withOpacity(.12)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500)),
              Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}