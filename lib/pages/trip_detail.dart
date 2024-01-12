import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:travel_planner/models/full_trip.dart';
import 'package:travel_planner/models/trip.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;
  final FullTrip fulltrip;
  final Function(String) onDelete;

  TripDetailPage({
    required this.trip,
    required this.fulltrip,
    required this.onDelete,
  });

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
    widget.fulltrip.details = [];

    int numberOfDays =
        widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;
    for (var i = 0; i < numberOfDays; i++) {
      placeController.add(TextEditingController());
      transportationController.add(TextEditingController());
      destinationController.add(TextEditingController());
      foodController.add(TextEditingController());
      costController.add(TextEditingController());
    }

    _loadDetails().then((_) {
      for (int index = 0; index < widget.fulltrip.details.length; index++) {
        placeController[index].text =
            widget.fulltrip.details[index].placeToStay;
        transportationController[index].text =
            widget.fulltrip.details[index].transportation;
        destinationController[index].text =
            widget.fulltrip.details[index].destination;
        foodController[index].text = widget.fulltrip.details[index].food;
        costController[index].text =
            widget.fulltrip.details[index].cost.toString();
      }
    });
  }

  Future<void> _loadDetails() async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trip_details/${widget.trip.id}.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        for (int index = 0; index < placeController.length; index++) {
          if (data.containsKey('$index')) {
            final detail = data['$index'];
            widget.fulltrip.details.add(FullTrip(
              placeToStay: detail['placeToStay'],
              transportation: detail['transportation'],
              destination: detail['destination'],
              food: detail['food'],
              cost: detail['cost'] ?? 0.0,
            ));
          }
        }

        // Set the text controllers with the loaded data
        for (int index = 0; index < widget.fulltrip.details.length; index++) {
          placeController[index].text =
              widget.fulltrip.details[index].placeToStay;
          transportationController[index].text =
              widget.fulltrip.details[index].transportation;
          destinationController[index].text =
              widget.fulltrip.details[index].destination;
          foodController[index].text = widget.fulltrip.details[index].food;
          costController[index].text =
              widget.fulltrip.details[index].cost.toString();
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
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
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side text
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Place to stay:'),
                        Divider(),
                        Text('Transportation:'),
                        Divider(),
                        Text('Destination:'),
                        Divider(),
                        Text('Food:'),
                        Divider(),
                        Text('Cost:'),
                        Divider(),
                      ],
                    ),
                    // Right side EditableText
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: EditableText(
                            controller: placeController[index],
                            readOnly: false,
                            focusNode: FocusNode(),
                            cursorColor: Colors.black,
                            backgroundCursorColor: Colors.black,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: EditableText(
                            controller: transportationController[index],
                            readOnly: false,
                            focusNode: FocusNode(),
                            cursorColor: Colors.black,
                            backgroundCursorColor: Colors.black,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: EditableText(
                            controller: destinationController[index],
                            readOnly: false,
                            focusNode: FocusNode(),
                            cursorColor: Colors.black,
                            backgroundCursorColor: Colors.black,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: EditableText(
                            controller: foodController[index],
                            readOnly: false,
                            focusNode: FocusNode(),
                            cursorColor: Colors.black,
                            backgroundCursorColor: Colors.black,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: EditableText(
                            controller: costController[index],
                            readOnly: false,
                            focusNode: FocusNode(),
                            cursorColor: Colors.black,
                            backgroundCursorColor: Colors.black,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                      ],
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

  void _editDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Details'),
          content: TextField(
            controller: placeController[index],
            decoration: InputDecoration(labelText: 'Place to stay'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle any additional logic for saving changes
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() async {
    // Ensure details property is initialized as a List
    // for (int index = 0; index < costController.length; index++) {
    //   widget.fulltrip.details.add(FullTrip(
    //     placeToStay: placeController[index].text,
    //     transportation: transportationController[index].text,
    //     destination: destinationController[index].text,
    //     food: foodController[index].text,
    //     cost: double.parse(costController[index].text),
    //   ));

    // }
    for (int index = 0; index < costController.length; index++) {
      FullTrip newDetails = FullTrip(
        placeToStay: placeController[index].text,
        transportation: transportationController[index].text,
        destination: destinationController[index].text,
        food: foodController[index].text,
        cost: double.parse(costController[index].text),
      );

      // Update or add the new details to the list
      if (index < widget.fulltrip.details.length) {
        widget.fulltrip.details[index] = newDetails;
      } else {
        widget.fulltrip.details.add(newDetails);
      }

      // Update the corresponding TextEditingController values
      placeController[index].text = newDetails.placeToStay;
      transportationController[index].text = newDetails.transportation;
      destinationController[index].text = newDetails.destination;
      foodController[index].text = newDetails.food;
      costController[index].text = newDetails.cost.toString();
    }

    // Save details to the database
    await _saveDetails();

    // Display a message or navigate to a different screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Details saved successfully!'),
      ),
    );
  }

  Future<void> _saveDetails() async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trip_details/${widget.trip.id}.json',
      );

      final Map<String, dynamic> detailsData = {};

      for (int index = 0; index < widget.fulltrip.details.length; index++) {
        detailsData['$index'] = {
          'placeToStay': widget.fulltrip.details[index].placeToStay,
          'transportation': widget.fulltrip.details[index].transportation,
          'destination': widget.fulltrip.details[index].destination,
          'food': widget.fulltrip.details[index].food,
          'cost': widget.fulltrip.details[index].cost,
        };
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(detailsData),
      );

      if (response.statusCode != 200) {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }

  void _deleteTrip() async {
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
              onPressed: () async {
                // Perform deletion logic
                _handleDelete();

                // Pass the deleted trip ID back to the home page
                Navigator.of(context).pop(widget.trip.id);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _handleDelete() async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trip_details/${widget.trip.id}.json',
      );

      final response = await http.delete(url);

      if (response.statusCode != 200) {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
    }

    // Call the onDelete callback with the trip id
    widget.onDelete(widget.trip.id);
    Navigator.of(context).pop(); // Close the dialog
  }

  // Future<void> _deleteDetails() async {
  //   try {
  //     final url = Uri.https(
  //       'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
  //       'trip_details/${widget.trip.id}.json',
  //     );

  //     final response = await http.delete(url);

  //     if (response.statusCode != 200) {
  //       print('Error: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print('Exception: $error');
  //   }
  // }
}
