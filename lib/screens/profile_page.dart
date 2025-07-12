import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'animewatchlist.dart';
import 'splash_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Your Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.deepPurpleAccent)
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            const Text("Otaku Name", style: TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.deepPurpleAccent),
              title: const Text("My Watchlist", style: TextStyle(color: Colors.white)),
              onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (_)=> const WatchlistPage()),);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepPurpleAccent),
              title: const Text("Settings", style: TextStyle(color: Colors.white)),
              onTap: () {
                // You can add settings navigation here later if needed
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurpleAccent),
              title: const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
