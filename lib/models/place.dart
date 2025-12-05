class Place {
  final String placeId;
  final String name;
  final double? lat;
  final double? lon;
  final String? categories;
  final double? distance;
  final String? address;
  final String? city;
  final String? country;

  Place({
    required this.placeId,
    required this.name,
    this.lat,
    this.lon,
    this.categories,
    this.distance,
    this.address,
    this.city,
    this.country,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    try {
      final properties = json['properties'] ?? {};
      final geometry = json['geometry'];
      
      double? latitude;
      double? longitude;
      
      if (geometry != null && geometry['coordinates'] != null) {
        final coords = geometry['coordinates'];
        if (coords is List && coords.length >= 2) {
          longitude = coords[0]?.toDouble();
          latitude = coords[1]?.toDouble();
        }
      }

      // Get name from multiple possible fields
      String placeName = properties['name']?.toString() ?? 
                        properties['street']?.toString() ??
                        properties['address_line1']?.toString() ??
                        properties['formatted']?.toString() ??
                        'Unknown Place';

      return Place(
        placeId: properties['place_id']?.toString() ?? 
                 json['id']?.toString() ?? 
                 DateTime.now().millisecondsSinceEpoch.toString(),
        name: placeName,
        lat: latitude,
        lon: longitude,
        categories: properties['categories'] is List
            ? (properties['categories'] as List).join(',')
            : properties['categories']?.toString(),
        distance: properties['distance']?.toDouble(),
        address: properties['formatted']?.toString() ?? 
                 properties['address_line1']?.toString() ??
                 properties['address_line2']?.toString(),
        city: properties['city']?.toString() ?? 
              properties['county']?.toString() ??
              properties['state']?.toString(),
        country: properties['country']?.toString(),
      );
    } catch (e) {
      print('Error parsing Place: $e');
      print('JSON: $json');
      return Place(
        placeId: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Unknown Place',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': placeId,
      'properties': {
        'place_id': placeId,
        'name': name,
        'categories': categories,
        'distance': distance,
        'formatted': address,
        'address_line1': address,
        'city': city,
        'country': country,
      },
      'geometry': {
        'coordinates': [lon, lat],
      },
    };
  }
}
