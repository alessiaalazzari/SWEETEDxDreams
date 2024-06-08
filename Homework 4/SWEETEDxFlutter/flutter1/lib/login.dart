import 'package:flutter/material.dart';
import 'package:flutter1/homescreen.dart';
import 'package:flutter1/talk_repository.dart';

class LoginPage extends StatefulWidget {
  final int page;
  final String initTag;

  const LoginPage({super.key,
    this.page = 0,
    this.initTag = ''
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final response = await login(_emailController.text, _passwordController.text);

    setState(() {
      _message = response;
    });

    if (response == 'login successful') {
      // Redirect to MainNavigation after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MySearchPage()),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFF3), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 80),
            const Center(
              child: Text(
                'SWEETEDx DREAMS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                fillColor: Colors.grey[300],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: Colors.grey[300],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 8),
            Text(
              _message,
              style: TextStyle(
                color: _message == 'login successful' ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
   /*   bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
        currentIndex: 2, // Seleziona il tab 'Login'
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),*/
    );
  }
}
