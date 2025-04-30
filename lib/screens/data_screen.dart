// lib/screens/data_screen.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class DataScreen extends StatefulWidget {
  final String tableName;
  const DataScreen({required this.tableName});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  static const int _pageSize = 50;
  List<Map<String, dynamic>> _rows = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _offset = 0;
  late ScrollController _ctrl;
  late List<String> _columns;

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController()..addListener(_onScroll);
    _loadChunk();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading || !_hasMore) return;
    if (_ctrl.position.pixels >= _ctrl.position.maxScrollExtent - 200) {
      _loadChunk();
    }
  }

  Future<void> _loadChunk() async {
    setState(() => _isLoading = true);

    final chunk = await DBHelper.getTableDataPaged(
      widget.tableName,
      limit: _pageSize,
      offset: _offset,
    );

    if (_offset == 0 && chunk.isNotEmpty) {
      // ilk yüklemede sütun isimlerini kaydet
      _columns = chunk.first.keys.toList();
    }

    setState(() {
      _rows.addAll(chunk);
      _offset += chunk.length;
      _hasMore = chunk.length == _pageSize;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tableName)),
      body: _rows.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _columns.length * 150.0, // yaklaşık sütun genişliği
                child: ListView.builder(
                  controller: _ctrl,
                  itemCount: _rows.length + (_hasMore ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i == _rows.length) {
                      // liste sonuna gelince yükleme göstergesi
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final row = _rows[i];
                    return Row(
                      children: _columns.map((col) {
                        return Container(
                          width: 150,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            row[col]?.toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          if (!_hasMore)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Tüm veri yüklendi.', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }
}
