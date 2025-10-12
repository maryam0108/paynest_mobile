class AppTransaction {
  final String id;
  final DateTime date;
  final String merchant;
  final String walletId;   // link to WalletModel.id
  final String category;   // e.g., Food, Transport...
  final double amount;     // negative = expense, positive = income

  AppTransaction({
    required this.id,
    required this.date,
    required this.merchant,
    required this.walletId,
    required this.category,
    required this.amount,
  });
}