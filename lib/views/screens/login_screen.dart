// login_page.dart

import 'package:euro_wings/views/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'admin_panel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement authentication logic here
                // For simplicity, assume the login is always successful
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminPanel()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
