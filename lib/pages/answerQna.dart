// AnswerPage.dart

import 'package:flutter/material.dart';
import 'package:travel_planner/models/qna_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnswerPage extends StatefulWidget {
  final QnA question;

  AnswerPage({required this.question});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _answerController = TextEditingController();
  List<String> answers = [];

  @override
  void initState() {
    super.initState();
    _fetchAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answers for: ${widget.question.question}'),
      ),
      body: Column(
        children: [
          Text('Answers Count: ${answers.length}'), // Add this line
          _buildAnswerList(),
          _buildAddAnswerForm(),
        ],
      ),
    );
  }

  Widget _buildAnswerList() {
    print('Building Answer List: ${answers.length}');
    return Expanded(
      child: ListView.builder(
        itemCount: answers.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(answers[index]),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddAnswerForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Add an answer'),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _addAnswer(),
            child: Text('Add Answer'),
          ),
        ],
      ),
    );
  }

  Future<void> _addAnswer() async {
    try {
      final String answerText = _answerController.text
          .trim(); // Trim to remove leading and trailing spaces

      if (answerText.isEmpty) {
        // Show a message or handle the case where the answer is empty
        print('Empty answer is not valid');
        return;
      }

      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      final Uri url = Uri.https(
          'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
          'qna/${widget.question.id}/answers/$id.json');

      final http.Response response = await http.post(
        url,
        body: json.encode({'answer': _answerController.text}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _fetchAnswers();
        _answerController
            .clear(); //clear the text field after the answer submit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Answer added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Error adding answer: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error adding answer: $error');
    }
  }

  Future<void> _fetchAnswers() async {
    try {
      final Uri url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'qna/${widget.question.id}.json',
      );

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null && data.containsKey('answers')) {
          List<String> fetchedAnswers = [];

          final answersData = data['answers'];

          if (answersData != null && answersData is Map<String, dynamic>) {
            answersData.forEach((key, value) {
              if (value is String) {
                fetchedAnswers.add(value);
              } else if (value is Map<String, dynamic> &&
                  value.containsKey('answer')) {
                fetchedAnswers.add(value['answer']);
              } else if (value is Map<String, dynamic>) {
                // Handle nested answers
                value.forEach((nestedKey, nestedValue) {
                  if (nestedValue is Map<String, dynamic> &&
                      nestedValue.containsKey('answer')) {
                    fetchedAnswers.add(nestedValue['answer']);
                  }
                });
              }
            });
          }

          setState(() {
            answers = List.from(fetchedAnswers.reversed);
          });

          print('Fetched Answers: $answers');
        } else {
          print('No answers data available');
        }
      } else {
        print('Error fetching answers. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Exception: $error');
    }
  }
}
