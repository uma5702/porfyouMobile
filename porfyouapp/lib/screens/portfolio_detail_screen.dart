import 'package:flutter/material.dart';

class PortfolioDetailScreen extends StatelessWidget {
  const PortfolioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Detail'),
      ),
      body: const Center(
        child: Text('Portfolio Detail Screen'),
      ),
    );
  }
}
