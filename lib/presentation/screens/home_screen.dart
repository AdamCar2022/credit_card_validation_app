import 'dart:ui';
import 'package:flutter/material.dart';

class CardHomeScreen extends StatelessWidget {
  const CardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/pexels-karolina-grabowska-4968638.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Adams Card Validator',
                          style: TextStyle(fontSize: 30, fontFamily: 'Arial'),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      try {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushReplacementNamed('/add_card');
                      } catch (e, stack) {
                        debugPrint('Navigation failed: $e\n$stack');
                      }
                    },
                    child: const Center(child: Text('Get Started')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
