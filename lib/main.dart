import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage(); // Secure storage
  var imageSource = "images/question-mark.png"; // Initial image source

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on startup
  }

  Future<void> _loadSavedCredentials() async {
    String? savedUsername = await _storage.read(key: 'username');
    String? savedPassword = await _storage.read(key: 'password');
    if (savedUsername != null && savedPassword != null) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Loaded saved credentials'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _usernameController.clear();
                _passwordController.clear();
              });
            },
          ),
        ),
      );
    }
  }

  void _login() {
    String password = _passwordController.text;

    setState(() {
      if (password == "QWERTY123") {
        imageSource = "images/idea.png"; // Correct password image
      } else {
        imageSource = "images/stop.png"; // Incorrect password image
      }
    });

    _showSaveDialog();
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Credentials"),
          content: const Text("Would you like to save your username and password for next time?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCredentials(); // Don't save
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(); // Save credentials
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCredentials() async {
    await _storage.write(key: 'username', value: _usernameController.text);
    await _storage.write(key: 'password', value: _passwordController.text);
  }

  Future<void> _clearCredentials() async {
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Login name field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Login name',
              ),
            ),
            const SizedBox(height: 16.0),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide text
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),

            // Login button
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _usernameController.clear();
                  _passwordController.clear();
                });

                // Optional: Provide user feedback using a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fields have been reset!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Red color for the Undo button
              ),
              child: const Text('Undo'),
            ),
            const SizedBox(height: 16),

            // Image that changes based on password
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
