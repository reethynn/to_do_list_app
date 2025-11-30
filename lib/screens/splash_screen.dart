import 'package:flutter/material.dart';
import 'login_screen.dart'; // arah setelah splash

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 3 detik, lalu masuk ke login
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            // 📝 Logo Gambar dari assets
            LogoWidget(),

            SizedBox(height: 12),
            Text(
              "Dailist",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFB6B9), // lembut pastel pink
                letterSpacing: 1.2,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

// Widget logo dengan efek gradien pastel di atas gambar asset
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFFFFB6B9), // pink pastel
            Color(0xFFFFDDE1), // peach lembut
            Color(0xFFA8EDEA), // hijau kebiruan pastel
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Image.asset(
        'assets/images/logo.png', // ganti dengan nama file logomu
        height: 120,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported,
              size: 100, color: Colors.grey);
        },
      ),
    );
  }
}
