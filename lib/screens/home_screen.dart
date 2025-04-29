import 'package:flutter/material.dart';
import 'package:iddaa/services/database_service.dart';
import 'package:iddaa/models/match_model.dart';
import 'package:iddaa/screens/match_detail_screen.dart';
import 'package:iddaa/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  final String filePath;
  const HomeScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, TextEditingController> _controllers = {};
  List<String> _columns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadColumns();
  }

  Future<void> _loadColumns() async {
    try {
      await DatabaseService.instance.loadDatabase(widget.filePath);
      List<String> columns = await DatabaseService.instance.getColumns('matches');
      columns.remove('id');
      setState(() {
        _columns = columns;
        for (var col in _columns) {
          _controllers[col] = TextEditingController();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veritabanı yüklenemedi: $e")),
      );
    }
  }

  Future<void> _analyze() async {
    final matches = await DatabaseService.instance.fetchAllMatches();
    Map<String, double> userInputs = {};
    _controllers.forEach((key, controller) {
      if (controller.text.trim().isNotEmpty) {
        final value = double.tryParse(controller.text.trim());
        if (value != null) {
          userInputs[key] = value;
        }
      }
    });

    if (userInputs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir oran giriniz.')),
      );
      return;
    }

    MatchModel? closestMatch;
    double closestDiff = double.infinity;

    for (var match in matches) {
      double totalDiff = 0;
      for (var entry in userInputs.entries) {
        final matchValue = double.tryParse(match.data[entry.key] ?? '');
        if (matchValue != null) {
          totalDiff += (matchValue - entry.value).abs();
        } else {
          totalDiff += 1000;
        }
      }

      if (totalDiff < closestDiff) {
        closestDiff = totalDiff;
        closestMatch = match;
      }
    }

    if (closestMatch != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchDetailScreen(match: closestMatch!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uygun maç bulunamadı.')),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: LoadingWidget()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oran Girişi ve Analiz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ..._columns.map((col) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TextField(
                  controller: _controllers[col],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: col,
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyze,
              child: const Text('Analiz Et ve Maçı Göster'),
            ),
          ],
        ),
      ),
    );
  }
}
