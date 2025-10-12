import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/budget.dart';
import 'package:paynest_mobile/screens/budget/budget_detail_page.dart';
import 'package:paynest_mobile/screens/budget/create_budget_page.dart';

class BudgetPage extends StatefulWidget {
  final List<BudgetModel> budgets;
  final void Function(BudgetModel) onBudgetAdded;

  const BudgetPage({
    super.key,
    required this.budgets,
    required this.onBudgetAdded,
  });

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {

  Future<void> _openCreate() async {
    final result = await Navigator.of(context).push<BudgetModel>(
      MaterialPageRoute(builder: (_) => const CreateBudgetPage()),
    );
    if (result != null) {
      widget.onBudgetAdded(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget saved ✅')),
      );
      setState(() {}); // refresh UI
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBudget = widget.budgets.isNotEmpty;

    return Stack(
      children: [
        if (!hasBudget)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pie_chart_outline, size: 58, color: Colors.white70),
                const SizedBox(height: 10),
                Text('No budget yet', style: GoogleFonts.inter(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 6),
                Text('Tap the + on the top-right to create your first budget.',
                    style: GoogleFonts.inter(color: Colors.white54)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openCreate,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Budget'),
                ),
              ],
            ),
          ),

        if (hasBudget)
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // We'll use the latest budget as active
                Builder(builder: (context) {
                  final active = widget.budgets.last;

                  // Linear progress tracking budget vs spent
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budget Usage', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: active.progress, // spent / total
                          minHeight: 12,
                          backgroundColor: Colors.white.withOpacity(.15),
                          color: const Color(0xFF14B8A6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Spent TSh ${active.totalSpent.toStringAsFixed(0)} / TSh ${active.total.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 16),

                      // Summary card (total + duration)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.05),
                          border: Border.all(color: Colors.white.withOpacity(.1)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Active Budget', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total: TSh ${active.total.toStringAsFixed(0)}',
                                    style: GoogleFonts.inter(color: Colors.white70),
                                  ),
                                  Text('Duration: ${active.durationLabel}', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.calendar_month, color: Colors.white70),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

                // List of budgets (most recent first)
                Text('Your Budgets', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Column(
  children: widget.budgets.reversed.map((b) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BudgetDetailPage(budget: b)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          border: Border.all(color: Colors.white.withOpacity(.1)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TSh ${b.total.toStringAsFixed(0)}', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(b.durationLabel, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: b.progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(.12),
                      color: const Color(0xFF14B8A6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Spent TSh ${b.totalSpent.toStringAsFixed(0)} / ${b.total.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.navigate_next, color: Colors.white70),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => BudgetDetailPage(budget: b)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }).toList(),
),
              ],
            ),
          ),

        // Add button in AppBar: we can't place here; HomeShell handles it via actions.
      ],
    );
  }
}