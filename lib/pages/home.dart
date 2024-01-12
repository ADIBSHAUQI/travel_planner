import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:travel_planner/models/full_trip.dart';
import 'package:travel_planner/pages/places_preview.dart';
import 'package:travel_planner/pages/qna.dart';
import 'package:travel_planner/pages/sign_in.dart';
import 'package:travel_planner/pages/trip_detail.dart';
import 'package:travel_planner/widgets/custom_icon_button.dart';
import 'package:travel_planner/models/trip.dart';
import 'package:travel_planner/pages/new_trip.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Trip> _trips = [];

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trips.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Trip> trips = [];

          data.forEach((key, value) {
            DateTime startDate = DateTime.parse(value['startDate']);
            DateTime endDate = DateTime.parse(value['endDate']);

            int duration = endDate.difference(startDate).inDays;

            trips.add(Trip(
              id: key,
              place: value['place'],
              startDate: startDate,
              endDate: endDate,
              duration: duration,
            ));
          });

          setState(() {
            _trips = trips;
          });
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("TABII"),
          ],
        ),
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
                      cost: 0.0,
                    ),
                    onDelete: _handleTripDeletion,
                  ),
                ),
              ).then((result) {
                // Handle any result if needed
              });
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
              _logout();
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
          selectedTrip: {},
          dates: {},
          trips: [],
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
      (route) => false,
    );
  }

  // Function to delete trip data from the database
  Future<void> _deleteTripData(String tripId) async {
    try {
      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'trips/$tripId.json',
      );

      final response = await http.delete(url);

      if (response.statusCode != 200) {
        print('Error deleting trip data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception deleting trip data: $error');
    }
  }

  // Function to handle trip deletion
  void _handleTripDeletion(String tripId) async {
    // Delete data from the database
    await _deleteTripData(tripId);

    // Update the local list
    setState(() {
      _trips.removeWhere((trip) => trip.id == tripId);
    });
  }
}
