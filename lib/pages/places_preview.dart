import 'package:flutter/material.dart';
import 'package:travel_planner/pages/home.dart';
import 'package:travel_planner/pages/qna.dart';

class PlacesPreviewPage extends StatelessWidget {
  final List<String> placeCategories = [
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
    'Kuala Lumpur',
  ];

  final List<Color> cardColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
    Colors.deepOrange,
    Colors.lime,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications action
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: placeCategories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToPlaceList(context, placeCategories[index]);
            },
            child: Card(
              elevation: 2.0,
              color: cardColors[index % cardColors.length],
              child: Center(
                child: Text(
                  placeCategories[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.place),
              onPressed: () {
                // Already on the PlacesPreviewPage
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
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

  void _navigateToPlaceList(BuildContext context, String category) {
    // Navigate to a new page displaying a list of places for the selected category
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceListPage(category: category),
      ),
    );
  }
}

class PlaceListPage extends StatelessWidget {
  final String category;

  PlaceListPage({required this.category});

  @override
  Widget build(BuildContext context) {
    List<PlaceInfo> places = [];

    // Add places based on the selected category
    switch (category) {
      case 'Johor':
        places = [
          PlaceInfo(
              'Johor Ancient Temple',
              'Lot 653, Jalan Trus, Bandar Johor Bahru, 80000 Johor Bahru, Johor',
              'assets/images/Johor/old-temple.jpg'),
          PlaceInfo('Legoland Malaysia', 'Iskandar Puteri, Johor, Malaysia.',
              'assets/images/Johor/legoland.jpg'),
          PlaceInfo(
              'Firefly Valley Leisure Park',
              'Jalan Jemaluang, 81900 Kota Tinggi, Johor',
              'assets/images/Johor/firefly.jpg'),
        ];
        break;
      case 'Melaka':
        places = [
          PlaceInfo('A Famosa', 'Alor Gajah, Melaka.',
              'assets/images/Melaka/afamosa.jpg'),
          PlaceInfo(
              'Jonker Street',
              'Jalan Hang Jebat, 75200 Melaka, Malaysia.',
              'assets/images/Melaka/jonker.jpg'),
          PlaceInfo(
              'Malacca Sultanate Palace Museum',
              'Kota, Complex Warisan, 75000 Malacca, Malaysia.',
              'assets/images/Melaka/malacca-palace.jpg'),
        ];
        break;
      case 'Pahang':
        places = [
          PlaceInfo('Cameron Highlands', 'Pahang.',
              'assets/images/Pahang/cameron.jpg'),
          PlaceInfo('Genting Highlands', 'Bentong, Pahang.',
              'assets/images/Pahang/genting.jpg'),
          PlaceInfo('Tioman Island', 'Rompin, Pahang.',
              'assets/images/Pahang/tioman.jpg'),
        ];
        break;
      case 'Negeri Sembilan':
        places = [
          PlaceInfo(
              'Sri Sendayan Mosque',
              'Persiaran Idaman Villa, Bandar Sri Sendayan, 71950 Siliau, Negeri Sembilan.',
              'assets/images/Negeri Sembilan/sendayan.jpg'),
          PlaceInfo('Port Dickson', 'Port Dicson, 71000 Negeri Sembilan.',
              'assets/images/Negeri Sembilan/portdickson.jpg'),
          PlaceInfo('Gunung Datuk', '71350 Kota, Negeri Sembilan.',
              'assets/images/Negeri Sembilan/datuk.jpg'),
        ];
        break;
      case 'Selangor':
        places = [
          PlaceInfo('Batu Caves', 'Gombak, Selangor.',
              'assets/images/Selangor/batu-caves.jpg'),
          PlaceInfo(
              'National Zoo of Malaysia',
              'Jalan Taman Zooview, Taman Zooview, 68000 Ampang, Selangor.',
              'assets/images/Selangor/nat-zoo.jpg'),
          PlaceInfo(
              'Sunway Pyramid',
              '3, Jalan PJS 11/15, Bandar Sunway, 47500 Petaling Jaya, Selangor.',
              'assets/images/Selangor/sunway.jpg'),
        ];
        break;
      case 'Perak':
        places = [
          PlaceInfo(
              'Ipoh World at Han Chin Pet Soo',
              '3, Jalan Bijeh Timah, 30000 Ipoh, Perak.',
              'assets/images/Perak/ipoh-world.jpg'),
          PlaceInfo(
              'Kellies Castle',
              'Lot 48436, Kompleks Pelancongan Kellies Castle, KM 5.5, Jalan Gopeng, 31000 Batu Gajah, Perak.',
              'assets/images/Perak/kellies.jpg'),
          PlaceInfo(
              'Taiping Lake Garden',
              'Jalan Pekeliling, Taman Tasik Taiping, 34000 Taiping, Perak.',
              'assets/images/Perak/lake-garden.jpg'),
        ];
        break;
      case 'Terengganu':
        places = [
          PlaceInfo(
              'Terengganu State Museum',
              '20566 Bukit Losong, Terengganu.',
              'assets/images/Terengganu/state-museum.jpg'),
          PlaceInfo('Chinatown', 'Kuala Terengganu, Terengganu.',
              'assets/images/Terengganu/kampungcina.jpg'),
          PlaceInfo(
              'Crystal Mosque',
              'Pulau Wan Man, Losong Panglima Perang, 21000 Kuala Terengganu, Terengganu.',
              'assets/images/Terengganu/crystal-mosque.jpg'),
        ];
        break;
      case 'Kelantan':
        places = [
          PlaceInfo(
              'Istana Jahar',
              'Jalan Sultan, Bandar Kota Bharu, 15000 Kota Bharu, Kelantan.',
              'assets/images/Kelantan/jahar.jpg'),
          PlaceInfo(
              'Stong Hill',
              'Taman Negeri Gunung Stong Kampung Jelawang, 18200 Dabong, Kelantan.',
              'assets/images/Kelantan/stong.jpg'),
          PlaceInfo('Wat Mai Suwankiri', 'Description for Beach 3',
              'assets/images/Kelantan/watmai.JPG'),
        ];
        break;
      case 'Pulau Pinang':
        places = [
          PlaceInfo('ESCAPE Penang', 'Description for Beach 1',
              'assets/images/Pulau Pinang/escape.jpg'),
          PlaceInfo('Penang Hill', 'Description for Beach 2',
              'assets/images/Pulau Pinang/penang-hill.jpg'),
          PlaceInfo('Pinang Peranakan Mansion', '16200 Tumpat, Kelantan.',
              'assets/images/Pulau Pinang/pinang-peranakan.jpg'),
        ];
        break;
      case 'Kedah':
        places = [
          PlaceInfo(
              'Zahir Mosque',
              'Jalan Kampung Perak, Bandar Alor Setar, 05150 Alor Setar, Kedah.',
              'assets/images/Kedah/masjid-zahir.jpg'),
          PlaceInfo('Sky Bridge', '07000 Langkawi, Kedah.',
              'assets/images/Kedah/sky-bridge.jpg'),
          PlaceInfo('Oriental Village', '07000 Langkawi, Kedah.',
              'assets/images/Kedah/oriental-village.jpg'),
        ];
        break;
      case 'Perlis':
        places = [
          PlaceInfo('Kelam Cave', 'Jalan Kaki Bukit, 02200 Kaki Bukit, Perlis',
              'assets/images/Perlis/kelam.jpg'),
          PlaceInfo(
              'Arau Royal Gallery',
              '14 A, Batu 1, Jln Abi Tok Hashim, Kampung Alor Panjang, 01000 Kangar, Perlis.',
              'assets/images/Perlis/royal-gallery.jpg'),
          PlaceInfo('Wang Kelian', '02200 Kaki Bukit, Perlis.',
              'assets/images/Perlis/wang-kelian.jpg'),
        ];
        break;
      case 'Sabah':
        places = [
          PlaceInfo(
              'Mount Kinabalu',
              'Ranau district, West Coast Division of Sabah, Malaysia.',
              'assets/images/Sabah/kinabalu.jpg'),
          PlaceInfo(
              'Mari Mari Cultural Village',
              'Jalan Kionsom, Inanam, 88450 Kota Kinabalu, Sabah.',
              'assets/images/Sabah/marimari.jpg'),
          PlaceInfo(
              'Desa Cattle Dairy Farm',
              'Jalan Cinta Mata Mesilou, 89308 Kundasang, Sabah.',
              'assets/images/Sabah/desa-cattle.jpg'),
        ];
        break;
      case 'Sarawak':
        places = [
          PlaceInfo('Bako National Park', 'Sarawak.',
              'assets/images/Sarawak/bako.jpg'),
          PlaceInfo(
              'Matang Wildlife Centre',
              'Kampung Rayu, 93050 Kuching, Sarawak.',
              'assets/images/Sarawak/matang.jpg'),
          PlaceInfo(
              'Sarawak Cultural Village',
              'Pantai Damai Santubong, Kampung Budaya Sarawak, 93752 Kuching, Sarawak.',
              'assets/images/Sarawak/sarawak-village.jpg'),
        ];
        break;
      case 'Kuala Lumpur':
        places = [
          PlaceInfo(
              'Petronas Twin Towers',
              'Kuala Lumpur City Centre, 50088 Kuala Lumpur.',
              'assets/images/Kuala Lumpur/twin-towers.jpg'),
          PlaceInfo(
              'Islamic Arts Museum Malaysia',
              'Jalan Lembah, Tasik Perdana, 50480 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur.',
              'assets/images/Kuala Lumpur/iamm.jpg'),
          PlaceInfo(
              'Kuala Lumpur Butterfly Park',
              'Jalan Cenderawasih, Tasik Perdana, 50480 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur.',
              'assets/images/Kuala Lumpur/butterfly-park.jpg'),
        ];
        break;
      // Add cases for other categories as needed
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Places'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].name),
            subtitle: Text(places[index].description),
            leading: Image.asset(
              places[index].imagePath,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String description;
  final String imagePath;

  PlaceInfo(this.name, this.description, this.imagePath);
}
