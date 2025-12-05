import '../config/app_config.dart';

class ApiEndpoint {
  // Places API - Daftar tempat wisata berdasarkan lokasi
  static String placesByRadius({
    required double lat,
    required double lon,
    int? radius,
    String? categories,
    int limit = 50,
  }) {
    final r = radius ?? AppConfig.defaultRadius;
    
    // Default categories untuk wisata
    String categoryFilter = categories != null && categories.isNotEmpty 
        ? categories 
        : 'tourism,tourism.sights,tourism.attraction,tourism.information,natural,beach,entertainment,heritage,national_park';
    
    // Filter menggunakan circle
    String filter = 'circle:$lon,$lat,$r';
    
    var url = '${AppConfig.baseUrl}/v2/places?'
        'categories=$categoryFilter&'
        'filter=$filter&'
        'limit=$limit&'
        'apiKey=${AppConfig.apiKey}';
    
    return url;
  }

  // Places API - Daftar tempat wisata berdasarkan bounding box
  static String placesByBbox({
    required double lonMin,
    required double latMin,
    required double lonMax,
    required double latMax,
    String? categories,
    int limit = 50,
  }) {
    String categoryFilter = categories != null && categories.isNotEmpty 
        ? categories 
        : 'tourism,tourism.sights,tourism.attraction,natural,beach,entertainment,heritage';
    
    String filter = 'rect:$lonMin,$latMin,$lonMax,$latMax';
    
    var url = '${AppConfig.baseUrl}/v2/places?'
        'categories=$categoryFilter&'
        'filter=$filter&'
        'limit=$limit&'
        'apiKey=${AppConfig.apiKey}';
    
    return url;
  }

  // Autocomplete API - Untuk fitur search
  static String autocomplete({
    required String text,
    double? lat,
    double? lon,
    int limit = 20,
  }) {
    var url = '${AppConfig.baseUrl}/v1/geocode/autocomplete?'
        'text=${Uri.encodeComponent(text)}&'
        'limit=$limit&'
        'apiKey=${AppConfig.apiKey}';
    
    // Tambahkan bias location jika ada
    if (lat != null && lon != null) {
      url += '&bias=proximity:$lon,$lat';
    }
    
    // Filter untuk Indonesia
    url += '&filter=countrycode:id';
    
    return url;
  }

  // Place Details API - Detail tempat wisata
  static String placeDetail(String placeId) {
    return '${AppConfig.baseUrl}/v2/place-details?'
        'id=${Uri.encodeComponent(placeId)}&'
        'apiKey=${AppConfig.apiKey}';
  }
}
