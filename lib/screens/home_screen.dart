import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'All',
    'Work',
    'Personal',
    'Wishlist',
    'Others'
  ];

  // Daftar task
  final List<Map<String, dynamic>> _tasks = [];

  // 🔹 POPUP TAMBAH TASK
  void _showAddTaskPopup() {
    final TextEditingController taskController = TextEditingController();
    bool isBellActive = false;
    String selectedCategory = "No Category";

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add New Task",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Input field
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: "Input new task here",
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFB6B9)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFB6B9)),
                      ),
                      suffixIcon: StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                isBellActive = !isBellActive;
                              });
                            },
                            child: Icon(
                              Icons.notifications_rounded,
                              color: isBellActive
                                  ? const Color(0xFFFFE066)
                                  : Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Row kategori + icon + tombol check
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedCategory,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFFFFB6B9),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (taskController.text.trim().isEmpty) return;
                          setState(() {
                            _tasks.add({
                              'task': taskController.text.trim(),
                              'category': selectedCategory,
                              'reminder': isBellActive,
                              'done': false,
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFA8EDEA),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 GANTI STATUS TASK SAAT DICENTANG (aman terhadap null)
  void _toggleTaskDone(int index) {
    setState(() {
      final bool current = _tasks[index]['done'] ?? false;
      _tasks[index]['done'] = !current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black87),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black87),
          SizedBox(width: 12),
        ],
      ),

      // BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C9C9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Daftar Task
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text(
                      "No tasks yet",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final bool done = task['done'] ?? false;
                      final bool reminder = task['reminder'] ?? false;
                      final String title = (task['task'] ?? '').toString();
                      final String category = (task['category'] ?? '').toString();

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Checkbox custom
                            GestureDetector(
                              onTap: () => _toggleTaskDone(index),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: done
                                        ? const Color(0xFFA8EDEA)
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: done
                                      ? const Color(0xFFA8EDEA)
                                      : Colors.transparent,
                                ),
                                child: done
                                    ? const Icon(Icons.check,
                                        size: 18, color: Colors.white)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Judul dan kategori
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: done ? Colors.grey : Colors.black87,
                                      decoration: done
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Icon pengingat
                            Icon(
                              reminder
                                  ? Icons.notifications_active_rounded
                                  : Icons.notifications_off_rounded,
                              color:
                                  reminder ? const Color(0xFFFFE066) : Colors.grey.shade400,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 10, right: 10),
  child: GestureDetector(
    onTap: _showAddTaskPopup,
    child: Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFD2E9FF), // biru muda lembut
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          size: 38,
          color: Colors.white,
        ),
      ),
    ),
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
