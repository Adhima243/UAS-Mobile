class AppConfig {
  // Geoapify API Configuration
  static const String apiKey = 'f7b6ce9498c64e56909620f25631dd47';
  static const String baseUrl = 'https://api.geoapify.com';
  
  // Search & Filter Settings
  static const int defaultRadius = 50000; // 50km dalam meter
  static const int defaultLimit = 50;
  
  // Default location (Yogyakarta, Indonesia)
  static const double defaultLat = -7.7956;
  static const double defaultLon = 110.3695;
  
  // Indonesia bounding box coordinates
  static const double indonesiaLatMin = -11.0;
  static const double indonesiaLatMax = 6.0;
  static const double indonesiaLonMin = 95.0;
  static const double indonesiaLonMax = 141.0;
}
