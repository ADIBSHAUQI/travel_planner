class FullTrip {
  List<FullTrip> details = [];
  String placeToStay;
  String transportation;
  String destination;
  String food;
  double cost;

  FullTrip(
      {required this.placeToStay,
      required this.transportation,
      required this.destination,
      required this.food,
      required this.cost});
}
