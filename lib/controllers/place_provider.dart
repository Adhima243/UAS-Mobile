import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';
import '../services/place_service.dart';
import '../utils/location_helper.dart';

class PlaceProvider with ChangeNotifier {
  final PlaceService _placeService = PlaceService();
  
  List<Place> _places = [];
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  String _selectedCategory = '';

  List<Place> get places => _places;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;
  String get selectedCategory => _selectedCategory;

  Future<void> loadPlaces({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🏠 PlaceProvider: Loading places...');
      
      _currentPosition = await LocationHelper.getCurrentLocation();
      _currentPosition ??= LocationHelper.getDefaultLocation();

      print('📍 Position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      print('🏷️ Category: ${category ?? "all"}');

      _places = await _placeService.getPlacesByRadius(
        lat: _currentPosition!.latitude,
        lon: _currentPosition!.longitude,
        categories: category,
      );

      print('✅ Loaded ${_places.length} places');
      
      if (_places.isEmpty) {
        print('⚠️ No places found, try changing location or category');
      }
      
      _selectedCategory = category ?? '';
      _error = null;
    } catch (e) {
      print('❌ PlaceProvider Error: $e');
      _error = 'Gagal memuat data: ${e.toString()}';
      _places = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    loadPlaces(category: category.isEmpty ? null : category);
  }

  void updateLocation(double lat, double lon) {
    _currentPosition = Position(
      latitude: lat,
      longitude: lon,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    loadPlaces(category: _selectedCategory.isEmpty ? null : _selectedCategory);
  }
}
