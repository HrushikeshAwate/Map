import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../location_service.dart';
import '../firebase_db.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationService = context.watch<LocationService>();
    final locationHistory = locationService.locationHistory;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: locationHistory.isEmpty
                ? const Center(child: Text("Waiting for location updates..."))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Latitude')),
                          DataColumn(label: Text('Longitude')),
                          DataColumn(label: Text('Speed')),
                          DataColumn(label: Text('Timestamp')),
                        ],
                        rows: locationHistory.map((entry) {
                          return DataRow(cells: [
                            DataCell(Text(entry['latitude'].toString())),
                            DataCell(Text(entry['longitude'].toString())),
                            DataCell(Text(entry['speed'].toString())),
                            DataCell(Text(entry['timestamp'].toString())),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    locationService.clearLocationHistory();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Clear Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 146, 54, 244),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () async {
                //     await uploadAllLocationsToFirebase();
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text("Data synced to Firebase")),
                //     );
                //   },
                //   icon: const Icon(Icons.cloud_upload),
                //   label: const Text("Sync to Firebase"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(255, 0, 180, 90),
                //     foregroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
