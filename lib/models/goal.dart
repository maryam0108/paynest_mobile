class GoalModel {
  final String id;
  final String name;
  final double target;          // target amount
  final DateTime startDate;
  final DateTime endDate;
  final String frequency;       // Weekly, Biweekly, Monthly, etc.
  final double current;         // amount saved so far

  GoalModel({
    required this.id,
    required this.name,
    required this.target,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    this.current = 0,
  });

  GoalModel copyWith({
    String? name,
    double? target,
    DateTime? startDate,
    DateTime? endDate,
    String? frequency,
    double? current,
  }) {
    return GoalModel(
      id: id,
      name: name ?? this.name,
      target: target ?? this.target,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      current: current ?? this.current,
    );
  }

  double get progress => target <= 0 ? 0.0 : (current / target).clamp(0, 1);
  String get durationLabel =>
      '${startDate.toString().substring(0,10)} → ${endDate.toString().substring(0,10)}';
}