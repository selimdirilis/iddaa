import 'package:flutter/material.dart';
import 'package:iddaa/models/match_model.dart';

class MatchDetailScreen extends StatelessWidget {
  final MatchModel match;

  const MatchDetailScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maç Detayı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: match.data.entries.map((e) {
          return ListTile(
            title: Text(e.key),
            subtitle: Text(e.value),
          );
        }).toList(),
      ),
    );
  }
}
