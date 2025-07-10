import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../location_service.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationHistory = context.watch<LocationService>().locationHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Location Table')),
      body: locationHistory.isEmpty
          ? const Center(child: Text("Waiting for location updates..."))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Latitude')),
                    DataColumn(label: Text('Longitude')),
                    DataColumn(label: Text('Timestamp')),
                  ],
                  rows: locationHistory.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(entry['latitude'].toString())),
                      DataCell(Text(entry['longitude'].toString())),
                      DataCell(Text(entry['timestamp'].toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
