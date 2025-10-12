import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/widgets/app_button.dart';
import 'package:paynest_mobile/widgets/app_input.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/models/goal.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  State<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final nameCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now().add(const Duration(days: 90));
  String frequency = 'Monthly';

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

  void _save() {
    final name = nameCtrl.text.trim();
    final target = double.tryParse(targetCtrl.text.trim()) ?? 0;
    if (name.isEmpty || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and a valid target')),
      );
      return;
    }
    final model = GoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      target: target,
      startDate: start,
      endDate: end,
      frequency: frequency,
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
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text('Create Goal', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w600)),
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
                  AppInput(controller: nameCtrl, hint: 'Goal name (e.g., Laptop, Emergency fund)'),
                  const SizedBox(height: 12),
                  AppInput(controller: targetCtrl, hint: 'Target amount (TSh)', type: TextInputType.number),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickStart,
                          child: Text('Start: ${start.toString().substring(0,10)}'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickEnd,
                          child: Text('End: ${end.toString().substring(0,10)}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Deposit frequency', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
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
                        value: frequency,
                        dropdownColor: const Color(0xFF0B2533),
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more, color: Colors.white70),
                        items: const [
                          DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                          DropdownMenuItem(value: 'Biweekly', child: Text('Biweekly')),
                          DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                          DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
                        ],
                        onChanged: (v) => setState(() => frequency = v ?? frequency),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  AppButton(label: 'Save Goal', onPressed: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}