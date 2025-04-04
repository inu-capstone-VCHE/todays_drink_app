class DrinkingRecord {
  final DateTime date;
  final String title;
  final double sojuAmount;
  final String? sojuUnit;
  final double beerAmount;
  final String? beerUnit;

  DrinkingRecord({
    required this.date,
    required this.title,
    required this.sojuAmount,
    required this.sojuUnit,
    required this.beerAmount,
    required this.beerUnit,
  });
}