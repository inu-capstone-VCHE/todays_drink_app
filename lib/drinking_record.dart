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

  static List<DrinkingRecord> fromJsonList(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    final title = json['title'];
    final List<String> types = json['type'].split(',');
    final List<String> counts = json['count'].split(',');
    final List<String> units = json['unit'].split(',');

    List<DrinkingRecord> records = [];

    for (int i = 0; i < types.length; i++) {
      final type = types[i];
      final double count = double.tryParse(counts[i]) ?? 0.0;
      final String? unit = units[i];

      records.add(DrinkingRecord(
        date: date,
        title: title,
        sojuAmount: type == "soju" ? count : 0.0,
        sojuUnit: type == "soju" ? unit : null,
        beerAmount: type == "beer" ? count : 0.0,
        beerUnit: type == "beer" ? unit : null,
      ));
    }

    return records;
  }
}
