import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:travel_planner/models/full_trip.dart';
import 'package:travel_planner/pages/places_preview.dart';
import 'package:travel_planner/pages/qna.dart';
import 'package:travel_planner/pages/trip_detail.dart';
import 'package:travel_planner/widgets/custom_icon_button.dart';
import 'package:travel_planner/models/trip.dart';
import 'package:intl/intl.dart';
//import 'package:travel_planner/models/user.dart';
import 'package:travel_planner/pages/new_trip.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Trip> _trips = [];
  Map<String, bool> _selectedTrip = {};
  Map<String, DateTime> _dates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello"),
          ],
        ),
        actions: [
          CustomIconButton(
            icon: Icon(Ionicons.search_outline),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 12),
            child: CustomIconButton(
              icon: Icon(Ionicons.notifications_outline),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailPage(
                    trip: trip,
                    fulltrip: FullTrip(
                        placeToStay: '',
                        transportation: '',
                        destination: '',
                        food: '',
                        cost: 0.0),
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(
                trip.place,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${DateFormat.yMMMd().format(trip.startDate)} - ${DateFormat.yMMMd().format(trip.endDate)}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addingToDo,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle the "Home" button tap
              },
            ),
            IconButton(
              icon: Icon(Icons.place),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlacesPreviewPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Options'),
          ),
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text('QnA'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QnaPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Implement logout logic here
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }

  void _addingToDo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewTripDialog(
          onTripAdded: (Trip newTrip) {
            setState(() {
              _trips.add(newTrip);
            });
          },
          fulltrip: _trips,
          selectedTrip: _selectedTrip,
          dates: _dates,
          trips: [],
        );
      },
    );
  }
}
