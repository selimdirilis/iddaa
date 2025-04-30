// lib/main.dart
import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'screens/file_picker_screen.dart';
import 'screens/table_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  Future<bool> _prepareDb() async {
    // Eğer daha önce bir DB seçilmişse aç, yoksa false döndür
    if (await DBHelper.isDbImported()) {
      await DBHelper.openImportedDb();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic DB Viewer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: _prepareDb(),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Daha önce import edilmiş DB varsa tablo listesine, yoksa picker ekranına
          return snap.data == true
              ? TableListScreen()
              : FilePickerScreen();
        },
      ),
    );
  }
}
