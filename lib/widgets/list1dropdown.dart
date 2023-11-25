import 'package:flutter/material.dart';

class List1Dropdown extends StatefulWidget {
  final List<dynamic> columnData;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  List1Dropdown(
      {required this.columnData,
        required this.selectedValue,
        required this.onChanged});

  @override
  _List1DropdownState createState() => _List1DropdownState();
}

class _List1DropdownState extends State<List1Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        items: widget.columnData.map((item) {
          return DropdownMenuItem<String>(
            value: item.toString(),
            child: Text(item.toString()),
          );
        }).toList(),
        value: widget.selectedValue,
        onChanged: (value) {
          widget.onChanged(value!);
        },
      ),
    );
  }
}