import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:travel_planner/models/trip.dart';

class NewTripDialog extends StatefulWidget {
  final List<Trip> trips;
  final Map<String, bool> selectedTrip;
  final Map<String, DateTime> dates;
  final Function(Trip) onTripAdded;

  NewTripDialog({
    required this.trips,
    required this.selectedTrip,
    required this.dates,
    required this.onTripAdded,
  });

  @override
  _NewTripDialogState createState() => _NewTripDialogState();
}

class _NewTripDialogState extends State<NewTripDialog> {
  String? selectedLocation;
  DateTimeRange? selectedDateRange;

  Future<void> _saveTrip() async {
    try {
      print('Save Trip Button Pressed');

      if (selectedLocation != null && selectedDateRange != null) {
        print('Valid Input: $selectedLocation, $selectedDateRange');

        final url = Uri.https(
          'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
          'trips.json',
        );

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'place': selectedLocation,
            'startDate': selectedDateRange!.start.toIso8601String(),
            'endDate': selectedDateRange!.end.toIso8601String(),
          }),
        );

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          print('Trip saved successfully');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip saved successfully')),
          );

          String id = json.decode(response.body)['name'];

          Trip newTrip = Trip(
            id: id,
            place: selectedLocation!,
            startDate: selectedDateRange!.start,
            endDate: selectedDateRange!.end,
            duration: selectedDateRange!.end
                .difference(selectedDateRange!.start)
                .inDays,
          );

          widget.selectedTrip[id] = false;
          widget.dates[id] = selectedDateRange!.start;

          widget.onTripAdded(newTrip);

          Navigator.of(context).pop();
        } else {
          print('Error: ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save trip')),
          );
        }
      } else {
        print('Invalid Input: $selectedLocation, $selectedDateRange');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide valid input')),
        );
      }
    } catch (error) {
      print('Exception: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedLocation,
            onChanged: (value) {
              print('Selected Location: $value');
              setState(() {
                selectedLocation = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Location',
            ),
            items: _buildLocationDropdownItems(),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                print('Selected date range: $picked');
                setState(() {
                  selectedDateRange = picked;
                });
              }
            },
            child: Text('Select date range'),
          ),
          SizedBox(height: 10),
          Text(
            'Selected Date Range: ${selectedDateRange != null ? DateFormat.yMMMd().format(selectedDateRange!.start) : 'N/A'} - ${selectedDateRange != null ? DateFormat.yMMMd().format(selectedDateRange!.end) : 'N/A'}',
            style: TextStyle(fontSize: 14),
          ),
        ],
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
            _saveTrip();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildLocationDropdownItems() {
    // Replace this with your logic to fetch or provide a list of locations
    List<String> locations = [
      'Johor',
      'Melaka',
      'Pahang',
      'Negeri Sembilan',
      'Selangor',
      'Perak',
      'Terengganu',
      'Kelantan',
      'Pulau Pinang',
      'Kedah',
      'Perlis',
      'Sabah',
      'Sarawak',
      'Kuala Lumpur'
    ];

    return locations.map((location) {
      return DropdownMenuItem<String>(
        value: location,
        child: Text(location),
      );
    }).toList();
  }
}
