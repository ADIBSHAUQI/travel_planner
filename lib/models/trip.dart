class Trip {
  final String id;
  final String place;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  double cost;

  Trip({
    required this.id,
    required this.place,
    required this.startDate,
    required this.endDate,
    required this.duration,
    this.cost = 0.0, //default cost value
  });
}
