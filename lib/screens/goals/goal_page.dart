import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/goal.dart';
import 'package:paynest_mobile/screens/goals/create_goal_page.dart';
import 'package:paynest_mobile/screens/goals/goal_detail_page.dart';

class GoalPage extends StatefulWidget {
  final List<GoalModel> goals;
  final void Function(GoalModel) onGoalAdded;
  final void Function(GoalModel) onGoalUpdated; // to reflect add/withdraw

  const GoalPage({
    super.key,
    required this.goals,
    required this.onGoalAdded,
    required this.onGoalUpdated,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  Future<void> _openCreate() async {
    final res = await Navigator.of(context).push<GoalModel>(
      MaterialPageRoute(builder: (_) => const CreateGoalPage()),
    );
    if (res != null) {
      widget.onGoalAdded(res);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal created ✅')),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final has = widget.goals.isNotEmpty;

    return Stack(
      children: [
        if (!has)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flag_outlined, size: 58, color: Colors.white70),
                const SizedBox(height: 10),
                Text('No goals yet', style: GoogleFonts.inter(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 6),
                Text('Tap the + on the top-right to create your first goal.',
                    style: GoogleFonts.inter(color: Colors.white54)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openCreate,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Goal'),
                ),
              ],
            ),
          ),

        if (has)
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Goals', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Column(
                  children: widget.goals.reversed.map((g) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        final updated = await Navigator.of(context).push<GoalModel>(
                          MaterialPageRoute(builder: (_) => GoalDetailPage(goal: g)),
                        );
                        if (updated != null) {
                          widget.onGoalUpdated(updated);
                          setState(() {});
                        }
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
                            // progress circle thumbnail
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: g.progress,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withOpacity(.15),
                                    color: const Color(0xFF14B8A6),
                                  ),
                                  Center(
                                    child: Text('${(g.progress * 100).toStringAsFixed(0)}%',
                                        style: GoogleFonts.inter(fontSize: 10)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'TSh ${g.current.toStringAsFixed(0)} / ${g.target.toStringAsFixed(0)} • ${g.frequency}',
                                    style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.navigate_next, color: Colors.white70),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}