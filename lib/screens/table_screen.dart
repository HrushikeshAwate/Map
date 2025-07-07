import 'package:flutter/material.dart';
import 'package:map/location_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationList = Provider.of<LocationService>(context).locationList;

    return Scaffold(
      body: locationList.isEmpty
          ? const Center(child: Text("Waiting for location updates..."))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Latitude')),
                    DataColumn(label: Text('Longitude')),
                    DataColumn(label: Text('Time')),
                  ],
                  rows: locationList.map((loc) {
                    return DataRow(cells: [
                      DataCell(Text(loc['lat'].toString())),
                      DataCell(Text(loc['lng'].toString())),
                      DataCell(Text(
                        DateFormat('HH:mm:ss').format(DateTime.parse(loc['time'])),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
