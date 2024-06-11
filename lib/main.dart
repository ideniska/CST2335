import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter3/second.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var imageSource = "images/question-mark.png";
  bool _credentialsSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogin = prefs.getString('login');
    final savedPassword = prefs.getString('password');

    if (savedLogin != null && savedPassword != null) {
      _loginController.text = savedLogin;
      _passwordController.text = savedPassword;
      _credentialsSaved = true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login name and password loaded.'),
          action: SnackBarAction(
            label: 'Clear Saved Data',
            onPressed: _clearSavedData,
          ),
        ),
      );
    }
  }

  void _clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('password');
    _loginController.clear();
    _passwordController.clear();
    _credentialsSaved = false;
  }

  void _login() {
    setState(() {
      if (_passwordController.text == "QWERTY123") {
        imageSource = "images/idea.png";
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(loginName: _loginController.text)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome Back ${_loginController.text}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password')),
        );
        imageSource = "images/stop.png";
      }
    });

    if (!_credentialsSaved) {
      _showSaveDialog();
    }
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials'),
          content: const Text('Would you like to save your login name and password for next time?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _saveCredentials();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                _clearSavedData();
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('login', _loginController.text);
    prefs.setString('password', _passwordController.text);
    _credentialsSaved = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login name',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
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
