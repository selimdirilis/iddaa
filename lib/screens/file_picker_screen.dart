// lib/screens/file_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../db/db_helper.dart';
import 'table_list_screen.dart';

class FilePickerScreen extends StatefulWidget {
  @override
  _FilePickerScreenState createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _pickDb() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result == null) {
        setState(() => _loading = false);
        return;
      }
      final path = result.files.single.path!;
      await DBHelper.importDb(path);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TableListScreen()),
      );
    } catch (e) {
      setState(() {
        _error = 'DB yüklenirken hata: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite .db Seç')),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              icon: Icon(Icons.storage),
              label: Text('DB Dosyası Seç'),
              onPressed: _pickDb,
            ),
          ],
        ),
      ),
    );
  }
}
