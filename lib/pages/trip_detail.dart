import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner/models/full_trip.dart';
import 'package:travel_planner/models/trip.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;
  final FullTrip fulltrip;

  TripDetailPage({required this.trip, required this.fulltrip});

  @override
  _TripDetailPageState createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  List<TextEditingController> placeController = [];
  List<TextEditingController> transportationController = [];
  List<TextEditingController> destinationController = [];
  List<TextEditingController> foodController = [];
  List<TextEditingController> costController = [];

  @override
  void initState() {
    super.initState();
    widget.fulltrip.details = []; // Initialize details list
    int numberOfDays =
        widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;
    for (var i = 0; i < numberOfDays; i++) {
      placeController.add(TextEditingController());
      transportationController.add(TextEditingController());
      destinationController.add(TextEditingController());
      foodController.add(TextEditingController());
      costController.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    int numberOfDays =
        widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteTrip,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: numberOfDays,
          itemBuilder: (context, index) {
            final currentDate =
                widget.trip.startDate.add(Duration(days: index));
            return Card(
              child: ListTile(
                title: Text(DateFormat.yMMMd().format(currentDate)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: placeController[index],
                      decoration: InputDecoration(
                        labelText: 'Place to Stay',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    TextField(
                      controller: transportationController[index],
                      decoration: InputDecoration(
                        labelText: 'Transportation',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    TextField(
                      controller: destinationController[index],
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    TextField(
                      controller: foodController[index],
                      decoration: InputDecoration(
                        labelText: 'Food',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                    TextField(
                      controller: costController[index],
                      decoration: InputDecoration(
                        labelText: 'Cost',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _saveChanges() {
    // Ensure details property is initialized as a List
    for (int index = 0; index < costController.length; index++) {
      widget.fulltrip.details.add(FullTrip(
        placeToStay: placeController[index].text,
        transportation: transportationController[index].text,
        destination: destinationController[index].text,
        food: foodController[index].text,
        cost: double.parse(costController[index].text),
      ));
    }

    // Perform any additional save logic if needed

    // Display a message or navigate to a different screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Details saved successfully!'),
      ),
    );
  }

  void _deleteTrip() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Trip'),
          content: Text('Are you sure you want to delete this trip?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform deletion logic
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
