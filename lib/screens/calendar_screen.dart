import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const SizedBox(height: 40),

          // ==== HEADER: < Oct, 2025 > ====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                    });
                  },
                  child: const Icon(Icons.chevron_left, size: 24),
                ),

                Text(
                  "${_focusedDay.month.monthName}, ${_focusedDay.year}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                    });
                  },
                  child: const Icon(Icons.chevron_right, size: 24),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==== TABLE CALENDAR ====
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,

            headerVisible: false, // karena header custom di atas
            availableGestures: AvailableGestures.none, // supaya tidak bisa swipe ganti bulan (seperti contoh)

            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.black),
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              weekendStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),

            calendarFormat: CalendarFormat.month,
          ),

          const SizedBox(height: 60),

          const Text(
            "Click + to create a new task.\nPlan your day on the calendar view clearly!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),

      // ==== FAB Kanan Bawah ====
      // ==== FAB Kanan Bawah (Mirip Contoh) ====
floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 10, right: 10),
  child: GestureDetector(
    onTap: () {
      // Aksi tombol tambah
    },
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

extension on int {
  String get monthName {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[this - 1];
  }
}
