import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    required List<Trip> fulltrip,
  });

  @override
  _NewTripDialogState createState() => _NewTripDialogState();
}

class _NewTripDialogState extends State<NewTripDialog> {
  String? selectedLocation;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedLocation,
            onChanged: (value) {
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
            _submitNewTrip();
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

  void _submitNewTrip() {
    if (selectedLocation != null && selectedDateRange != null) {
      String id = DateTime.now().toString();
      int duration =
          selectedDateRange!.end.difference(selectedDateRange!.start).inDays;

      Trip newTrip = Trip(
        id: id,
        place: selectedLocation!,
        startDate: selectedDateRange!.start,
        endDate: selectedDateRange!.end,
        duration: duration,
      );

      widget.selectedTrip[id] = false;
      widget.dates[id] = selectedDateRange!.start;

      widget.onTripAdded(newTrip);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all details')),
      );
    }
  }
}
