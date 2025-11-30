import 'package:flutter/material.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data emoji mood (bisa disimpan di assets juga kalau mau gambar sendiri)
    final List<Map<String, dynamic>> moods = [
      {'emoji': '😴', 'color': const Color(0xFFB39DDB)}, // unmotivated
      {'emoji': '😩', 'color': const Color(0xFFE57373)}, // tired
      {'emoji': '😉', 'color': const Color(0xFFFFB74D)}, // energetic
      {'emoji': '😊', 'color': const Color(0xFFFFF176)}, // happy
      {'emoji': '🙂', 'color': const Color(0xFF81C784)}, // calm
      {'emoji': '😐', 'color': const Color(0xFF64B5F6)}, // neutral
      {'emoji': '😒', 'color': const Color(0xFF7986CB)}, // annoyed
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji dalam layout melingkar
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: moods.map((mood) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, mood); // kirim data mood
                      },
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: mood['color'],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            mood['emoji'],
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                const Text(
                  "How’s your day?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Tombol close (X)
            Positioned(
              bottom: 40,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFB6B9),
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.close,
                      color: Color(0xFFFFB6B9), size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
