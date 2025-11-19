import 'package:flutter/material.dart';

void main() {
  runApp(const SteakMasterApp());
}

class SteakMasterApp extends StatelessWidget {
  const SteakMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SteakMaster',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7B3F00),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overlay = Colors.black.withOpacity(0.35);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/grill.jpg', fit: BoxFit.cover),
          Opacity(
            opacity: 0.6,
            child: IgnorePointer(
              child: Image.asset(
                'assets/smoke.gif',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.85),
                gaplessPlayback: true,
              ),
            ),
          ),
          Container(color: overlay),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SteakMaster',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Master the art of cooking steaks!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text("Let's Cook"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
