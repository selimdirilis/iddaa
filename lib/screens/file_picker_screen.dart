// file_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'home_screen.dart';

class FilePickerScreen extends StatelessWidget {
  const FilePickerScreen({super.key});

  Future<void> _pickDatabase(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        String path = result.files.single.path!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(filePath: path),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dosya seçilmedi.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(".db Dosyası Seç")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickDatabase(context),
          child: const Text("Dosya Seç"),
        ),
      ),
    );
  }
}
