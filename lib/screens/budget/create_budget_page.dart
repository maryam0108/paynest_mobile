import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/app_input.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/models/budget.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({super.key});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final totalCtrl = TextEditingController();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now().add(const Duration(days: 30));

  final List<BudgetCategory> categories = [
    BudgetCategory(name: 'Food', allocation: 0),
    BudgetCategory(name: 'Transport', allocation: 0),
    BudgetCategory(name: 'Health', allocation: 0),
    BudgetCategory(name: 'Entertainment', allocation: 0),
  ];

  /// Keep a stable controller per category index to avoid RangeError/lookup issues.
  final Map<int, TextEditingController> _catCtrls = {};

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  @override
  void dispose() {
    totalCtrl.dispose();
    for (final c in _catCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllers() {
    // Create controllers for any new indexes
    for (var i = 0; i < categories.length; i++) {
      _catCtrls[i] ??= TextEditingController(
        text: categories[i].allocation == 0
            ? ''
            : categories[i].allocation.toStringAsFixed(0),
      );
    }
    // Clean up extra controllers if categories got shorter (not the case here, but safe)
    _catCtrls.keys
        .where((i) => i >= categories.length)
        .toList()
        .forEach((i) {
      _catCtrls[i]?.dispose();
      _catCtrls.remove(i);
    });
    setState(() {}); // refresh bindings if needed
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => start = d);
  }

  Future<void> _pickEnd() async {
    final d = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: start,
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => end = d);
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (_) {
        final nameCtrl = TextEditingController();
        final amountCtrl = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color(0xFF0B2533),
          title: Text('Add category', style: GoogleFonts.inter(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Category name',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Allocation (TSh)',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (name.isNotEmpty && amt >= 0) {
                  setState(() {
                    categories.add(BudgetCategory(name: name, allocation: amt));
                    _ensureControllers(); // create controller for the new index
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _save() {
    final total = double.tryParse(totalCtrl.text.trim()) ?? 0;
    final model = BudgetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      total: total,
      startDate: start,
      endDate: end,
      categories: List.of(categories),
    );
    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar row with Back + Title (inside gradient scaffold)
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context), // ✅ Back button
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Back',
                ),
                const SizedBox(width: 4),
                Text('Create Budget',
                    style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                border: Border.all(color: Colors.white.withOpacity(.1)),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppInput(
                    controller: totalCtrl,
                    hint: 'Total budget (TSh)',
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickStart,
                          child: Text('Start: ${start.toString().substring(0, 10)}'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickEnd,
                          child: Text('End: ${end.toString().substring(0, 10)}'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Categories', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        onPressed: _addCategory,
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                        tooltip: 'Add category',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Category rows
                  Column(
                    children: List.generate(categories.length, (i) {
                      final c = categories[i];
                      final ctrl = _catCtrls[i]!;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.04),
                          border: Border.all(color: Colors.white.withOpacity(.08)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(c.name, style: GoogleFonts.inter())),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: ctrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'TSh',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                onChanged: (v) {
                                  final amt = double.tryParse(v) ?? 0;
                                  setState(() {
                                    // ✅ Update by index; do not use indexOf
                                    categories[i] = categories[i].copyWith(allocation: amt);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),
                  AppButton(label: 'Save Budget', onPressed: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}