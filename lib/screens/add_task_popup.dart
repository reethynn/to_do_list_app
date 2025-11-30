import 'package:flutter/material.dart';

class AddTaskPopup extends StatefulWidget {
  const AddTaskPopup({super.key});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final TextEditingController _taskController = TextEditingController();
  bool _isBellActive = false;
  String _selectedCategory = "No Category";

  void _toggleBell() {
    setState(() {
      _isBellActive = !_isBellActive;
    });
  }

  void _saveTask() {
    if (_taskController.text.trim().isEmpty) return;
    Navigator.pop(context, {
      'task': _taskController.text.trim(),
      'category': _selectedCategory,
      'reminder': _isBellActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Task",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              hintText: "Input new task here...",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFFB6B9)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFFB6B9)),
              ),
              suffixIcon: GestureDetector(
                onTap: _toggleBell,
                child: Icon(
                  Icons.notifications_rounded,
                  color: _isBellActive
                      ? const Color(0xFFFFE066)
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedCategory,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _saveTask,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFA8EDEA),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
