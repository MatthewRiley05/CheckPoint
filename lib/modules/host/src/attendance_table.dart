import 'package:flutter/material.dart';

class AttendanceTable extends StatelessWidget {
  final List<Map<String, String>> attendanceData;

  const AttendanceTable({super.key, required this.attendanceData});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Student ID')),
        DataColumn(label: Text('Timestamp')),
      ],
      rows: attendanceData
          .map(
            (entry) => DataRow(
              cells: [
                DataCell(Text(entry['name']!)),
                DataCell(Text(entry['studentId']!)),
                DataCell(Text(entry['timestamp']!)),
              ],
            ),
          )
          .toList(),
    );
  }
}
