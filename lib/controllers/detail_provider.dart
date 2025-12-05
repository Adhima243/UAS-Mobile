import 'package:flutter/material.dart';
import '../models/place_detail.dart';
import '../services/place_service.dart';

class DetailProvider with ChangeNotifier {
  final PlaceService _placeService = PlaceService();
  
  PlaceDetail? _placeDetail;
  bool _isLoading = false;
  String? _error;

  PlaceDetail? get placeDetail => _placeDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPlaceDetail(String placeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('📄 DetailProvider: Loading detail for $placeId');
      _placeDetail = await _placeService.getPlaceDetail(placeId);
      print('✅ Detail loaded: ${_placeDetail?.name}');
      _error = null;
    } catch (e) {
      print('❌ DetailProvider Error: $e');
      _error = 'Gagal memuat detail tempat';
      _placeDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _placeDetail = null;
    _error = null;
    _isLoading = false;
  }
}
