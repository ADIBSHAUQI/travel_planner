// import 'package:flutter/material.dart';
// import 'package:travel_planner/models/qna_info.dart';
// import 'package:travel_planner/pages/home.dart';
// import 'package:travel_planner/pages/places_preview.dart';

// class QnaPage extends StatefulWidget {
//   @override
//   _QnaPageState createState() => _QnaPageState();
// }

// class _QnaPageState extends State<QnaPage> {
//   List<QnA> qnaList = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QnA'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _addQuestion,
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context),
//       body: _buildQnAList(),
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.place),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => PlacesPreviewPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQnAList() {
//     return ListView.builder(
//       itemCount: qnaList.length,
//       itemBuilder: (context, index) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               title: Text(qnaList[index].question),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: qnaList[index]
//                     .answers
//                     .map((answer) => Text(answer))
//                     .toList(),
//               ),
//               onTap: () => _addAnswer(index),
//               onLongPress: () {},
//             ),
//             Divider(), // Add a divider for visual separation
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Text('Options'),
//           ),
//           ListTile(
//             leading: Icon(Icons.question_answer_outlined),
//             title: Text('QnA'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               // Implement logout logic here
//               Navigator.pop(context); // Close the drawer
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _addQuestion() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newQuestion = '';

//         return AlertDialog(
//           title: Text('Add a new question'),
//           content: TextFormField(
//             onChanged: (value) {
//               newQuestion = value;
//             },
//             decoration: InputDecoration(labelText: 'Question'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   qnaList.add(QnA(question: newQuestion));
//                 });
//                 Navigator.pop(context);
//                 // Show a Snackbar
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Question added successfully'),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _addAnswer(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String newAnswer = '';

//         return AlertDialog(
//           title: Text('Add an answer'),
//           content: TextFormField(
//             onChanged: (value) {
//               newAnswer = value;
//             },
//             decoration: InputDecoration(labelText: 'Answer'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   qnaList[index].addAnswer(newAnswer);
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travel_planner/models/qna_info.dart';
import 'package:travel_planner/pages/home.dart';
import 'package:travel_planner/pages/places_preview.dart';

class QnaPage extends StatefulWidget {
  @override
  _QnaPageState createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  final String baseUrl =
      'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app';
  List<QnA> qnaList = [];

  @override
  void initState() {
    super.initState();
    _fetchQnA();
  }

  Future<void> _fetchQnA() async {
    try {
      final url = Uri.https(baseUrl, 'qna.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        print('Received data: $data'); //check received data

        if (data != null) {
          List<QnA> loadedQnA = [];

          data.forEach((key, value) {
            loadedQnA.add(QnA.fromJson(value));
          });

          setState(() {
            qnaList = loadedQnA;
          });
          print('QnA List: $qnaList');
        }
      } else {
        print('Error fetching QnA: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }

  Future<void> _addQuestion(String newQuestion) async {
    try {
      final String id =
          DateTime.now().millisecondsSinceEpoch.toString(); // Unique id
      final url = Uri.https(baseUrl, 'qna.json');
      final response = await http.post(
        url,
        body: json.encode({'id': id, 'question': newQuestion, 'answers': []}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _fetchQnA();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Error adding question: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error adding question: $error');
    }
  }

  Future<void> _addAnswer(String id, String newAnswer) async {
    try {
      final url = Uri.https(baseUrl, 'qna/$id.json');
      final response = await http.patch(
        url,
        body: json.encode({
          'answer': [
            ...qnaList.firstWhere((q) => q.id == id).answers,
            newAnswer
          ]
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Error adding answer: ${response.reasonPhrase}');
      } else {
        _fetchQnA();
      }
    } catch (error) {
      print('Error adding answer: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addQuestionDialog(),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildQnAList(),
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

  Widget _buildQnAList() {
    return ListView.builder(
      itemCount: qnaList.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(qnaList[index].question),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: qnaList[index]
                    .answers
                    .map((answer) => Text(answer))
                    .toList(),
              ),
              onTap: () => _addAnswerDialog(qnaList[index].id),
              onLongPress: () {},
            ),
            Divider(),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
              Navigator.pop(context);
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

  void _addQuestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newQuestion = '';

        return AlertDialog(
          title: Text('Add a new question'),
          content: TextFormField(
            onChanged: (value) {
              newQuestion = value;
            },
            decoration: InputDecoration(labelText: 'Question'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addQuestion(newQuestion);
                Navigator.pop(context);
                _fetchQnA(); // Add this line to refresh the UI
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addAnswerDialog(String questionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newAnswer = '';

        return AlertDialog(
          title: Text('Add an answer'),
          content: TextFormField(
            onChanged: (value) {
              newAnswer = value;
            },
            decoration: InputDecoration(labelText: 'Answer'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addAnswer(questionId, newAnswer);
                Navigator.pop(context);
                _fetchQnA(); // Add this line to refresh the UI
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
