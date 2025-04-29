import 'package:flutter/material.dart';

class ColumnPickerScreen extends StatefulWidget {
  final List<String> columns;
  final void Function(List<String>) onSelected;

  const ColumnPickerScreen({Key? key, required this.columns, required this.onSelected}) : super(key: key);

  @override
  State<ColumnPickerScreen> createState() => _ColumnPickerScreenState();
}

class _ColumnPickerScreenState extends State<ColumnPickerScreen> {
  final List<String> _selectedColumns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kolonları Seç')),
      body: ListView.builder(
        itemCount: widget.columns.length,
        itemBuilder: (context, index) {
          final column = widget.columns[index];
          return CheckboxListTile(
            title: Text(column),
            value: _selectedColumns.contains(column),
            onChanged: (bool? selected) {
              setState(() {
                if (selected == true) {
                  _selectedColumns.add(column);
                } else {
                  _selectedColumns.remove(column);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onSelected(_selectedColumns);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
