import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';
import '../services/place_service.dart';
import '../utils/location_helper.dart';

class SearchProvider with ChangeNotifier {
  final PlaceService _placeService = PlaceService();
  
  List<Place> _searchResults = [];
  bool _isSearching = false;
  String? _error;
  String _query = '';

  List<Place> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get query => _query;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _query = '';
      notifyListeners();
      return;
    }

    _isSearching = true;
    _error = null;
    _query = query;
    notifyListeners();

    try {
      print('🔎 SearchProvider: Searching for "$query"');
      
      Position? position = await LocationHelper.getCurrentLocation();
      position ??= LocationHelper.getDefaultLocation();

      print('📍 Search position: ${position.latitude}, ${position.longitude}');

      _searchResults = await _placeService.searchPlaces(
        query: query,
        lat: position.latitude,
        lon: position.longitude,
      );

      print('✅ Found ${_searchResults.length} search results');
      
      if (_searchResults.isEmpty) {
        print('⚠️ No results found for "$query"');
      }
      
      _error = null;
    } catch (e) {
      print('❌ SearchProvider Error: $e');
      _error = 'Pencarian gagal. Coba kata kunci lain.';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _query = '';
    _error = null;
    notifyListeners();
  }
}
