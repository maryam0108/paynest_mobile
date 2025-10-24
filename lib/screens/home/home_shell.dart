import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paynest_mobile/models/budget.dart';
import 'package:paynest_mobile/models/goal.dart';
import 'package:paynest_mobile/models/transaction.dart';
import 'package:paynest_mobile/screens/auth/welcome_screen.dart';
import 'package:paynest_mobile/screens/budget/budget_page.dart';
import 'package:paynest_mobile/screens/budget/create_budget_page.dart';
import 'package:paynest_mobile/screens/goals/create_goal_page.dart';
import 'package:paynest_mobile/screens/goals/goal_page.dart';
import 'package:paynest_mobile/screens/pay/pay_scan_page.dart';
import 'package:paynest_mobile/screens/reports/reports_page.dart';
import 'package:paynest_mobile/theme/app_theme.dart';
import 'package:paynest_mobile/widgets/gradient_scaffold.dart';
import 'package:paynest_mobile/screens/wallet/wallet_page.dart';
import 'package:paynest_mobile/screens/placeholder/under_construction_page.dart';
import 'package:paynest_mobile/models/wallet.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  // Demo seed: one wallet by default (as requested)
  List<WalletModel> wallets = [
    WalletModel(id: 'mywallet', name: 'Wallet', type: 'Mobile Money', masked: '...1234', balance: 125000),
  ];
  List<BudgetModel> budgets = [];
  List<GoalModel> goals = [];
  List<AppTransaction> txns = [
  AppTransaction(
    id: 't1',
    date: DateTime.now().subtract(const Duration(days: 2)),
    merchant: 'Kahawa Cafe',
    walletId: 'mpesa',
    category: 'Food',
    amount: -5000, // expense
  ),
  AppTransaction(
    id: 't2',
    date: DateTime.now().subtract(const Duration(days: 1)),
    merchant: 'Salary',
    walletId: 'nmb',
    category: 'Income',
    amount: 850000, // income
  ),
  AppTransaction(
    id: 't3',
    date: DateTime.now().subtract(const Duration(days: 10)),
    merchant: 'Daladala',
    walletId: 'mpesa',
    category: 'Transport',
    amount: -1200,
  ),
];



void addGoal(GoalModel g) => setState(() => goals.add(g));
void updateGoal(GoalModel g) {
  final i = goals.indexWhere((x) => x.id == g.id);
  if (i >= 0) setState(() => goals[i] = g);
}


  // NEW: add budget
void addBudget(BudgetModel b) {
  setState(() => budgets.add(b));
}


  void addWallet(WalletModel w) {
    setState(() {
      // replace if same id already present, else add
      final i = wallets.indexWhere((x) => x.id == w.id);
      if (i >= 0) {
        wallets[i] = w;
      } else {
        wallets.add(w);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      WalletPage(wallets: wallets, onWalletAdded: addWallet),
      BudgetPage(budgets: budgets, onBudgetAdded: addBudget),
      PayScanPage(          
    wallets: wallets,
  ),
      GoalPage(goals: goals, onGoalAdded: addGoal, onGoalUpdated: updateGoal), 
      ReportsPage(wallets: wallets, transactions: txns), 
    ];

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          backgroundColor: const Color(0xFF0B2533),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.fingerprint, color: Color(0xFF99F6E4)),
                  title: Text('PayNest', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
                  subtitle: Text('Plan. Pay. Grow.', style: GoogleFonts.inter(color: Colors.white70)),
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white70),
                  title: Text('Logout', style: GoogleFonts.inter(color: Colors.white)),
                  onTap: () async {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out ✅')),
                    );
                    await Future.microtask(() {});
                    if (!mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (route) => false, // remove everything
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Text(
            ['Wallet', 'Budget', 'Pay', 'Goal', 'Reports'][index],
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          actions: [
          if (index == 1)
            IconButton(
              tooltip: 'Add budget',
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.of(context).push<BudgetModel>(
                  MaterialPageRoute(builder: (_) => const CreateBudgetPage()),
                );
                if (result != null) {
                  addBudget(result);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget saved ✅')),
                  );
                }
              },
            ),
             if (index == 3) // Goals
            IconButton(
              tooltip: 'Add goal',
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.of(context).push<GoalModel>(
                  MaterialPageRoute(builder: (_) => const CreateGoalPage()),
                );
                if (result != null) addGoal(result);
              },
            ),

        ],

        ),
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white.withOpacity(.06),
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(0xFF14B8A6).withOpacity(.22),
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
            NavigationDestination(icon: Icon(Icons.pie_chart_outline), selectedIcon: Icon(Icons.pie_chart), label: 'Budget'),
            NavigationDestination(icon: Icon(Icons.qr_code_scanner_outlined), selectedIcon: Icon(Icons.qr_code_scanner), label: 'Pay'),
            NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag), label: 'Goal'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Reports'),
          ],
        ),
      ),
    );
  }
}