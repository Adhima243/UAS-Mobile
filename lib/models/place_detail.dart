class PlaceDetail {
  final String placeId;
  final String name;
  final String? address;
  final double? lat;
  final double? lon;
  final String? categories;
  final String? description;
  final String? website;
  final String? phone;
  final String? openingHours;
  final List<String>? images;
  final String? city;
  final String? country;
  final String? postcode;
  final Map<String, dynamic>? datasource;

  PlaceDetail({
    required this.placeId,
    required this.name,
    this.address,
    this.lat,
    this.lon,
    this.categories,
    this.description,
    this.website,
    this.phone,
    this.openingHours,
    this.images,
    this.city,
    this.country,
    this.postcode,
    this.datasource,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
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

      List<String>? imageList;
      if (properties['image'] != null) {
        imageList = [properties['image'].toString()];
      }

      return PlaceDetail(
        placeId: properties['place_id']?.toString() ?? 
                 json['id']?.toString() ?? 
                 '',
        name: properties['name']?.toString() ?? 
              properties['street']?.toString() ?? 
              'Unknown Place',
        address: properties['address_line1']?.toString() ?? 
                 properties['formatted']?.toString() ?? 
                 'Address not available',
        lat: latitude,
        lon: longitude,
        categories: properties['categories'] is List
            ? (properties['categories'] as List).join(', ')
            : properties['categories']?.toString(),
        description: properties['description']?.toString() ?? 
                    properties['wiki_and_media']?['description']?.toString(),
        website: properties['website']?.toString() ?? 
                properties['datasource']?['raw']?['website']?.toString(),
        phone: properties['contact']?['phone']?.toString() ?? 
               properties['datasource']?['raw']?['phone']?.toString(),
        openingHours: properties['opening_hours']?.toString(),
        images: imageList,
        city: properties['city']?.toString(),
        country: properties['country']?.toString(),
        postcode: properties['postcode']?.toString(),
        datasource: properties['datasource'],
      );
    } catch (e) {
      print('Error parsing PlaceDetail: $e');
      return PlaceDetail(
        placeId: '',
        name: 'Unknown Place',
        address: 'Address not available',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': placeId,
      'properties': {
        'place_id': placeId,
        'name': name,
        'address_line1': address,
        'categories': categories,
        'description': description,
        'website': website,
        'contact': {'phone': phone},
        'opening_hours': openingHours,
        'image': images?.isNotEmpty == true ? images!.first : null,
        'city': city,
        'country': country,
        'postcode': postcode,
        'datasource': datasource,
      },
      'geometry': {
        'coordinates': [lon, lat],
      },
    };
  }
}
