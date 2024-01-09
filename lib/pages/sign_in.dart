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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // New variable for loading state

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 4) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      // Simulate network request delay
      await Future.delayed(Duration(seconds: 2));
      if (email == 'a@gmail.com' && password == '1234') {
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
          SnackBar(content: Text('Invalid email or password')),
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
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
                onFieldSubmitted: (_) =>
                    _login(context), // New line for UX enhancement
              ),
              SizedBox(height: 24),
              _isLoading // New loading indicator
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
