import 'dart:convert';
import 'dart:typed_data'; // ditambahkan untuk menampung bytes gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

ImageProvider imageFromBase64String(String base64String) {
  return MemoryImage(base64Decode(base64String));
}

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String? currentGender;
  final String? currentImage;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    this.currentGender,
    this.currentImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _imageBytes; // baru: simpan langsung bytes untuk preview
  late TextEditingController _nameController;
  String? _gender;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _gender = widget.currentGender;
    _savedImagePath = widget.currentImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // PILIH GAMBAR + SIMPAN
  Future<void> _pickImageAndSave() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // baca bytes langsung dari XFile agar kompatibel web & mobile
    final bytes = await pickedFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', base64Image);

    setState(() {
      _savedImagePath = base64Image;
      _imageBytes = bytes; // set bytes untuk preview langsung
    });
  }

  // SIMPAN PROFIL KE SHARED PREFERENCES
  void _saveProfile() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileName', name);
    await prefs.setString('profileGender', _gender!);
    await prefs.setString('profileImage', _savedImagePath ?? '');

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    // FIX GAMBAR BASE64 (ubah urutan: preview bytes dulu, lalu base64 ter-simpan, lalu gambar awal)
    ImageProvider? avatar;
    if (_imageBytes != null) {
      avatar = MemoryImage(_imageBytes!); // preview instan
    } else if (_savedImagePath != null && _savedImagePath!.isNotEmpty) {
      avatar = MemoryImage(
        base64Decode(_savedImagePath!),
      ); // ambil dari base64 tersimpan
    } else if (widget.currentImage != null && widget.currentImage!.isNotEmpty) {
      avatar = MemoryImage(base64Decode(widget.currentImage!)); // gambar awal
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // FOTO PROFIL (TAP UNTUK UBAH)
            GestureDetector(
              onTap: _pickImageAndSave,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: avatar,
                    child: avatar == null
                        ? const Icon(
                            Icons.person,
                            size: 55,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Edit Photo",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // NAME
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Name",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "fill your name",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5C9C9)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5C9C9)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // GENDER
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            RadioListTile<String>(
              title: const Text("Girl / Woman"),
              activeColor: const Color(0xFFF5C9C9),
              value: "Girl / Woman",
              groupValue: _gender,
              onChanged: (val) => setState(() => _gender = val),
            ),
            RadioListTile<String>(
              title: const Text("Boy / Man"),
              activeColor: const Color(0xFFA9CCD3),
              value: "Boy / Man",
              groupValue: _gender,
              onChanged: (val) => setState(() => _gender = val),
            ),

            const SizedBox(height: 50),

            // BUTTON SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA9D8F3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
