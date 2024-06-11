import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;

  ProfilePage({required this.loginName});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _userRepository.loadData(widget.loginName).then((userData) {
      setState(() {
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _phoneNumberController.text = userData['phoneNumber'] ?? '';
        _emailController.text = userData['email'] ?? '';
      });
    });
  }

  @override
  void dispose() {
    _userRepository.saveData(widget.loginName, {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
    });
    super.dispose();
  }

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('This URL is not supported on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _launchURL('tel:${_phoneNumberController.text}'),
                ),
                IconButton(
                  icon: Icon(Icons.sms),
                  onPressed: () => _launchURL('sms:${_phoneNumberController.text}'),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: () => _launchURL('mailto:${_emailController.text}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserRepository {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  Future<void> saveData(String loginName, Map<String, String> data) async {
    data.forEach((key, value) async {
      await _prefs.setString('$loginName-$key', value);
    });
  }

  Future<Map<String, String>> loadData(String loginName) async {
    Map<String, String> data = {};
    data['firstName'] = await _prefs.getString('$loginName-firstName') ?? '';
    data['lastName'] = await _prefs.getString('$loginName-lastName') ?? '';
    data['phoneNumber'] = await _prefs.getString('$loginName-phoneNumber') ?? '';
    data['email'] = await _prefs.getString('$loginName-email') ?? '';
    return data;
  }
}
