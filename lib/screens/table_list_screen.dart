// lib/screens/table_list_screen.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'filter_screen.dart';  // ← yeni

class TableListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tablolar')),
      body: FutureBuilder<List<String>>(
        future: DBHelper.getTables(),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          if (snap.hasError)
            return Center(child: Text('Hata: ${snap.error}'));
          final tables = snap.data!;
          if (tables.isEmpty)
            return Center(child: Text('DB içinde tablo yok.'));
          return ListView.builder(
            itemCount: tables.length,
            itemBuilder: (_, i) {
              final name = tables[i];
              return ListTile(
                title: Text(name),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FilterScreen(tableName: name)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
