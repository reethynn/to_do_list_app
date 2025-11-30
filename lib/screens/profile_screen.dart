import 'dart:convert';                     // WAJIB untuk BASE64
import 'dart:typed_data';                  // WAJIB buat MemoryImage
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'mood_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? imagePath;  // BASE64

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadProfileData(); // auto refresh ketika kembali dari edit
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('profileName') ?? "Edit Name";
      imagePath = prefs.getString('profileImage'); // AMBIL FOTO BASE64
    });
  }

  // CONVERTER BASE64 → Image
  ImageProvider imageFromBase64String(String base64String) {
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEDEE), // pink atas
              Colors.white,     // putih bawah
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ====================== HEADER PROFILE ======================
                Row(
                  children: [
                    // FOTO PROFILE
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (imagePath != null && imagePath!.isNotEmpty)
                          ? imageFromBase64String(imagePath!)   // FIX BASE64
                          : null,
                      child: (imagePath == null || imagePath!.isEmpty)
                          ? const Icon(Icons.person, size: 32, color: Colors.white)
                          : null,
                    ),

                    const SizedBox(width: 14),

                    // NAMA + BUTTON EDIT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (name != null && name!.isNotEmpty) ? name! : "Edit Name",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                  currentName: name ?? '',
                                  currentImage: imagePath,
                                  currentGender: null,
                                ),
                              ),
                            );

                            if (result == true) {
                              loadProfileData();  // AMBIL ULANG DATA
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 25),

                // ====================== STATISTIK TASK ======================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard("Completed Task", "0"),
                    _buildStatCard("Incomplete Task", "0"),
                  ],
                ),

                const SizedBox(height: 25),

                // ====================== MOOD SECTION ======================
                _buildMoodSection(context),

                const SizedBox(height: 25),

                // ====================== SETTINGS SECTION ======================
                _buildSettingsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================== WIDGET STAT ======================
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  // ====================== WIDGET MOOD ======================
  Widget _buildMoodSection(BuildContext context) {
    final days = ["M", "T", "W", "T", "F", "S", "S"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Moods",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MoodScreen()),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      days[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE4E7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  // ====================== WIDGET SETTINGS ======================
  Widget _buildSettingsSection(BuildContext context) {
    final items = [
      "Profile",
      "Account",
      "Theme",
      "Notification & Reminder",
      "Language"
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),

          ...items.map(
            (e) => ListTile(
              title: Text(e),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}
