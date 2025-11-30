import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _controller.forward(); // biar progress awal tidak null
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    // hanya animasi lengkungan
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,

      body: Padding(
  padding: const EdgeInsets.only(bottom: 90), 
  child: IndexedStack(
    index: _selectedIndex,
    children: _pages,
  ),
),


      bottomNavigationBar: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: BottomNavPainter(
              color: const Color(0xFFF5C9C9),
              selectedIndex: _selectedIndex,
              progress: _animation.value,
            ),
            child: SizedBox(
              height: 80,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.checklist_outlined, 0),
                  _navItem(Icons.calendar_month_outlined, 1),
                  _navItem(Icons.person_outline, 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, isSelected ? -8 : 0, 0),
        child: Icon(
          icon,
          size: isSelected ? 32 : 26,
          color: isSelected ? const Color(0xFFA9CCD3) : Colors.white,
        ),
      ),
    );
  }
}

/// 🎨 Background bottom navigation dengan lengkungan
class BottomNavPainter extends CustomPainter {
  final Color color;
  final int selectedIndex;
  final double progress;

  BottomNavPainter({
    required this.color,
    required this.selectedIndex,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final double width = size.width;
    final double sectionWidth = width / 3;

    final double centerX = sectionWidth * (selectedIndex + 0.5);

    const double curveWidth = 50;
    final double curveDepth = 25 * (1 - progress);

    final path = Path();
    path.moveTo(0, 0);

    path.lineTo(centerX - curveWidth, 0);

    path.quadraticBezierTo(
      centerX,
      curveDepth,
      centerX + curveWidth,
      0,
    );

    path.lineTo(width, 0);
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomNavPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.progress != progress;
  }
}
