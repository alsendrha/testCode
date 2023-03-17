import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_game/gamePage.dart';
import 'package:flutter_game/notation.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bottom.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('images/ox_ani.json'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 70),
                backgroundColor: Colors.white,
                elevation: 10,
              ),
              onPressed: () {
                Timer(const Duration(milliseconds: 500), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GamePage(),
                      ),
                      (route) => false);
                });
              },
              child: const Text('입장하기'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 70),
                backgroundColor: Colors.white,
                elevation: 10,
              ),
              onPressed: () {
                Timer(const Duration(milliseconds: 500), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notation(),
                      ),
                      (route) => false);
                });
              },
              child: const Text('기보보기'),
            ),
          ],
        ),
      ),
    );
  }
}
