import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:travel_planner/pages/home.dart';
import 'package:travel_planner/pages/register.dart';

class LoginPage extends StatefulWidget {
  static bool isLoggedIn = false; // Static variable to track login status
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // New variable for loading state

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your email';
  //   }
  //   if (!value.contains('@')) {
  //     return 'Invalid email format';
  //   }
  //   return null;
  // }
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      // Simulate network request delay
      await Future.delayed(Duration(seconds: 2));

      final url = Uri.https(
        'tabii-d8716-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users.json',
      );

      try {
        final response = await http.get(url);
        final Map<String, dynamic> users = json.decode(response.body);

        bool isValidUser = false;

        users.forEach((key, value) {
          if (value['username'] == username && value['password'] == password) {
            isValidUser = true;
          }
        });

        if (isValidUser) {
          setState(() {
            LoginPage.isLoggedIn = true; // Set isLoggedIn to true
            _isLoading = false; // Stop loading
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ); // Navigate to homepage
        } else {
          setState(() {
            _isLoading = false; // Stop loading
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (error) {
        print('Error retrieving user data: $error');
        setState(() {
          _isLoading = false; // Stop loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateUsername,
                textInputAction:
                    TextInputAction.next, // New line for UX enhancement
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validatePassword,
                onFieldSubmitted: (_) => _login(context),
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      child: Text('Login'),
                      onPressed: () {
                        _login(context);
                      },
                    ),
              TextButton(
                child: Text('Don\'t have an account? Register here'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
