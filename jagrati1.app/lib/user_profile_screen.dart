import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = _prefs?.getString('name') ?? '';
      _emailController.text = _prefs?.getString('email') ?? '';
      _locationController.text = _prefs?.getString('location') ?? '';
    });
  }

  Future<void> _saveUserProfile() async {
    if (_prefs != null) {
      await _prefs!.setString('name', _nameController.text);
      await _prefs!.setString('email', _emailController.text);
      await _prefs!.setString('location', _locationController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.yellowAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Home Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserProfile,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
