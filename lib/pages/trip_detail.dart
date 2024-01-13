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
  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trip_details/${widget.trip.id}.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (int index = 0; index < data.length; index++) {
          final detail = data[index];
          widget.fulltrip.details.add(FullTrip(
            placeToStay: detail['placeToStay'],
            transportation: detail['transportation'],
            destination: detail['destination'],
            food: detail['food'],
            cost: detail['cost'] ?? 0.0,
          ));
        }

        setState(() {}); // Trigger a rebuild to display the loaded data
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }

  Widget _buildListTile({
    required String title,
    required String data,
    required int index,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(data),
      onTap: () => _editDetails(title, index),
    );
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/gradient3.jpg"), //background image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 93, 93, 93), // Set background image opacity
              BlendMode.overlay, // adjust the blend mode
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: numberOfDays,
            itemBuilder: (context, index) {
              final currentDate =
                  widget.trip.startDate.add(Duration(days: index));
              final fullTrip = widget.fulltrip.details.length > index
                  ? widget.fulltrip.details[index]
                  : FullTrip(
                      placeToStay: '',
                      transportation: '',
                      destination: '',
                      food: '',
                      cost: 0.0,
                    );

              return Card(
                child: ListTile(
                  title: Text(DateFormat.yMMMd().format(currentDate)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile(
                          title: 'Place to stay',
                          data: fullTrip.placeToStay,
                          index: index),
                      _buildListTile(
                          title: 'Transportation',
                          data: fullTrip.transportation,
                          index: index),
                      _buildListTile(
                          title: 'Destination',
                          data: fullTrip.destination,
                          index: index),
                      _buildListTile(
                          title: 'Food', data: fullTrip.food, index: index),
                      _buildListTile(
                          title: 'Cost',
                          data: fullTrip.cost.toString(),
                          index: index),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _editDetails(String title, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
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
                setState(() {
                  // Handle any additional logic for saving changes
                  if (index < widget.fulltrip.details.length) {
                    // Update the existing data
                    switch (title) {
                      case 'Place to stay':
                        widget.fulltrip.details[index].placeToStay =
                            controller.text;
                        break;
                      case 'Transportation':
                        widget.fulltrip.details[index].transportation =
                            controller.text;
                        break;
                      case 'Destination':
                        widget.fulltrip.details[index].destination =
                            controller.text;
                        break;
                      case 'Food':
                        widget.fulltrip.details[index].food = controller.text;
                        break;
                      case 'Cost':
                        widget.fulltrip.details[index].cost =
                            double.parse(controller.text);
                        break;
                    }
                  } else {
                    // Add new data
                    switch (title) {
                      case 'Place to stay':
                        widget.fulltrip.details.add(FullTrip(
                            placeToStay: controller.text,
                            transportation: '',
                            destination: '',
                            food: '',
                            cost: 0.0));
                        break;
                      case 'Transportation':
                        widget.fulltrip.details.add(FullTrip(
                            placeToStay: '',
                            transportation: controller.text,
                            destination: '',
                            food: '',
                            cost: 0.0));
                        break;
                      case 'Destination':
                        widget.fulltrip.details.add(FullTrip(
                            placeToStay: '',
                            transportation: '',
                            destination: controller.text,
                            food: '',
                            cost: 0.0));
                        break;
                      case 'Food':
                        widget.fulltrip.details.add(FullTrip(
                            placeToStay: '',
                            transportation: '',
                            destination: '',
                            food: controller.text,
                            cost: 0.0));
                        break;
                      case 'Cost':
                        widget.fulltrip.details.add(FullTrip(
                            placeToStay: '',
                            transportation: '',
                            destination: '',
                            food: '',
                            cost: double.parse(controller.text)));
                        break;
                    }
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() async {
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

      final List<Map<String, dynamic>> detailsData = [];

      for (int index = 0; index < widget.fulltrip.details.length; index++) {
        detailsData.add({
          'placeToStay': widget.fulltrip.details[index].placeToStay,
          'transportation': widget.fulltrip.details[index].transportation,
          'destination': widget.fulltrip.details[index].destination,
          'food': widget.fulltrip.details[index].food,
          'cost': widget.fulltrip.details[index].cost,
        });
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
}
