import 'package:flutter/material.dart';

class HomeViewStaff extends StatelessWidget {
  const HomeViewStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to the Staff Home View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
