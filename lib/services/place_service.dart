import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../models/place_detail.dart';
import '../utils/api_endpoint.dart';

class PlaceService {
  // Get places by radius (circle filter)
  Future<List<Place>> getPlacesByRadius({
    required double lat,
    required double lon,
    int? radius,
    String? categories,
  }) async {
    try {
      final url = ApiEndpoint.placesByRadius(
        lat: lat,
        lon: lon,
        radius: radius,
        categories: categories,
      );

      print('🌍 Fetching places from: $url');

      final response = await http.get(Uri.parse(url));

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['features'] != null && data['features'] is List) {
          final List<dynamic> features = data['features'];
          print('✅ Found ${features.length} places');
          
          if (features.isEmpty) {
            print('⚠️ No places found in this area');
          }
          
          return features.map((json) => Place.fromJson(json)).toList();
        }
        
        print('⚠️ No features in response');
        return [];
      } else {
        print('❌ Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in getPlacesByRadius: $e');
      throw Exception('Error: $e');
    }
  }

  // Get place detail by ID
  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    try {
      final url = ApiEndpoint.placeDetail(placeId);
      
      print('🔍 Fetching place detail: $url');
      
      final response = await http.get(Uri.parse(url));

      print('📡 Detail response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['features'] != null && data['features'] is List && 
            (data['features'] as List).isNotEmpty) {
          print('✅ Place detail loaded');
          return PlaceDetail.fromJson(data['features'][0]);
        }
        
        print('⚠️ Using fallback detail parsing');
        return PlaceDetail.fromJson(data);
      } else {
        print('❌ Error: ${response.statusCode}');
        throw Exception('Failed to load place detail: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in getPlaceDetail: $e');
      throw Exception('Error: $e');
    }
  }

  // Search places using Autocomplete API
  Future<List<Place>> searchPlaces({
    required String query,
    double? lat,
    double? lon,
  }) async {
    try {
      lat ??= -7.7956;
      lon ??= 110.3695;
      
      final url = ApiEndpoint.autocomplete(
        text: query,
        lat: lat,
        lon: lon,
      );

      print('🔎 Searching: $url');

      final response = await http.get(Uri.parse(url));

      print('📡 Search response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['features'] != null && data['features'] is List) {
          final List<dynamic> features = data['features'];
          print('✅ Search found ${features.length} results');
          
          if (features.isEmpty) {
            print('⚠️ No search results found');
          }
          
          return features.map((json) => Place.fromJson(json)).toList();
        }
        
        print('⚠️ No features in search response');
        return [];
      } else {
        print('❌ Search error: ${response.statusCode}');
        throw Exception('Failed to search places: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in searchPlaces: $e');
      throw Exception('Error: $e');
    }
  }

  // Get places by bounding box
  Future<List<Place>> getPlacesByBbox({
    required double lonMin,
    required double latMin,
    required double lonMax,
    required double latMax,
    String? categories,
  }) async {
    try {
      final url = ApiEndpoint.placesByBbox(
        lonMin: lonMin,
        latMin: latMin,
        lonMax: lonMax,
        latMax: latMax,
        categories: categories,
      );

      print('🗺️ Fetching places by bbox: $url');

      final response = await http.get(Uri.parse(url));

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['features'] != null && data['features'] is List) {
          final List<dynamic> features = data['features'];
          print('✅ Found ${features.length} places in bbox');
          return features.map((json) => Place.fromJson(json)).toList();
        }
        
        return [];
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in getPlacesByBbox: $e');
      throw Exception('Error: $e');
    }
  }
}
