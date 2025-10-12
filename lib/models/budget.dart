class BudgetCategory {
  final String name;
  final double allocation;
  final double spent;

  BudgetCategory({
    required this.name,
    required this.allocation,
    this.spent = 0,
  });

  BudgetCategory copyWith({String? name, double? allocation, double? spent}) {
    return BudgetCategory(
      name: name ?? this.name,
      allocation: allocation ?? this.allocation,
      spent: spent ?? this.spent,
    );
    }
}

class BudgetModel {
  final String id;
  final double total;
  final DateTime startDate;
  final DateTime endDate;
  final List<BudgetCategory> categories;

  BudgetModel({
    required this.id,
    required this.total,
    required this.startDate,
    required this.endDate,
    required this.categories,
  });

  double get totalAllocated =>
      categories.fold(0, (a, c) => a + c.allocation);

  double get totalSpent =>
      categories.fold(0, (a, c) => a + c.spent);

  double get progress =>
      total == 0 ? 0 : (totalSpent / total).clamp(0, 1);

  String get durationLabel =>
      '${startDate.toString().substring(0,10)} → ${endDate.toString().substring(0,10)}';
}