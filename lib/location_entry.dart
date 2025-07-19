class LocationEntry {
  final int? id;
  final double latitude;
  final double longitude;
  final String timestamp;

  LocationEntry({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }

  factory LocationEntry.fromMap(Map<String, dynamic> map) {
    return LocationEntry(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: map['timestamp'],
    );
  }
}
