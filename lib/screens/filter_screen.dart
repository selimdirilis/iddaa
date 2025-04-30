// lib/screens/filter_screen.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class FilterScreen extends StatefulWidget {
  final String tableName;
  const FilterScreen({Key? key, required this.tableName}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> _columns = [];
  final Map<String, TextEditingController> _controllers = {};
  List<Map<String, dynamic>> _results = [];
  bool _loadingCols = true;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _loadColumns();
  }

  Future<void> _loadColumns() async {
    final cols = await DBHelper.getTableColumns(widget.tableName);
    setState(() {
      _columns = cols..remove('id'); // id’yi filtre alanından çıkarabilirsiniz
      _loadingCols = false;
      for (var col in _columns) {
        _controllers[col] = TextEditingController();
      }
    });
  }

  Future<void> _search() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _searching = true;
      _results = [];
    });

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];
    _controllers.forEach((col, ctrl) {
      final txt = ctrl.text.trim();
      if (txt.isNotEmpty) {
        whereClauses.add('"$col" = ?');
        whereArgs.add(txt);
      }
    });
    String where = whereClauses.join(' AND ');

    List<Map<String, dynamic>> rows = [];
    if (where.isNotEmpty) {
      rows = await DBHelper.queryWhere(
        widget.tableName,
        where: where,
        whereArgs: whereArgs,
      );
    }
    setState(() {
      _results = rows;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtrele: ${widget.tableName}')),
      body: _loadingCols
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Dinamik form alanları
                    ..._columns.map((col) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: TextFormField(
                        controller: _controllers[col],
                        decoration: InputDecoration(
                          labelText: col,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _search,
                      icon: Icon(Icons.search),
                      label: Text('Ara'),
                    ),
                    SizedBox(height: 16),
                    // Arama durumu / sonuçlar
                    if (_searching)
                      Center(child: CircularProgressIndicator()),
                    if (!_searching && _results.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _results.first.keys
                              .map((c) => DataColumn(label: Text(c)))
                              .toList(),
                          rows: _results.map((row) {
                            return DataRow(
                              cells: row.keys
                                  .map((c) =>
                                  DataCell(Text(row[c]?.toString() ?? '')))
                                  .toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    if (!_searching && _results.isEmpty)
                      Text('Eşleşen maç bulunamadı.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
