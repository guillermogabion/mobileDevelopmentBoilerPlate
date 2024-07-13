import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/home_screen.dart'; // Import your home screen

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to HomeScreen after login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
