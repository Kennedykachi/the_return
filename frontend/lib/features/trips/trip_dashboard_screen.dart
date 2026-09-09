import 'package:flutter/material.dart';

class TripDashboardScreen extends StatelessWidget {
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Your trip')),
        body: const Center(child: Text('Your pre-departure dashboard will appear here.')),
      );
}
