import 'package:flutter/material.dart';
import 'package:my_flutter_app/api_service.dart'; // Adjust the import path as per your project structure
import 'package:my_flutter_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;

  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> userData =
          await _apiService.fetchSelf(widget.accessToken);
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error fetching user data
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _userData != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome, ${_userData!['name']}!',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Logout logic: Navigate to LoginScreen and remove all other routes from the stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) =>
                                false, // Remove all other routes from the stack
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  )
                : const Text(
                    'User data not available',
                    style: TextStyle(fontSize: 18),
                  ),
      ),
    );
  }
}
