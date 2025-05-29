import 'package:flutter/material.dart';

class HomeViewManager extends StatelessWidget {
  const HomeViewManager({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to the Manager Home View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
