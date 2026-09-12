import 'package:flutter/material.dart';

class TripDashboardScreen extends StatelessWidget {
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Your trip')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Your Ghana adventure starts in', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('14 days', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 28),
            Card(child: ListTile(
              leading: const Icon(Icons.download_for_offline),
              title: const Text('Audio packs'),
              subtitle: const Text('Keep your guides available without data.'),
              trailing: FilledButton(onPressed: () {}, child: const Text('Download')),
            )),
            const SizedBox(height: 20),
            Text('Your squad', style: Theme.of(context).textTheme.titleLarge),
            const Card(child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.groups)),
              title: Text('Trip chat'),
              subtitle: Text('Ama: “Kakum first thing Saturday?”'),
              trailing: Icon(Icons.chevron_right),
            )),
            const SizedBox(height: 20),
            Text('Before you go', style: Theme.of(context).textTheme.titleLarge),
            const ListTile(leading: Icon(Icons.check_circle_outline), title: Text('Download your saved audio guides')),
            const ListTile(leading: Icon(Icons.check_circle_outline), title: Text('Share your itinerary with your squad')),
          ],
        ),
      );
}
