class WalletModel {
  final String id;
  final String name;
  final String type; // Bank / Mobile Money
  final String? masked; // masked account/phone
  final double balance;

  WalletModel({
    required this.id,
    required this.name,
    required this.type,
    this.masked,
    this.balance = 0,
  });

  WalletModel copyWith({double? balance}) =>
      WalletModel(id: id, name: name, type: type, masked: masked, balance: balance ?? this.balance);
}