import 'package:flutter/material.dart';
import '../db/favorite_db.dart';
import '../models/place_detail.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteDb _favoriteDb = FavoriteDb();
  
  List<PlaceDetail> _favorites = [];
  bool _isLoading = false;

  List<PlaceDetail> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await _favoriteDb.getFavorites();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addFavorite(PlaceDetail place) async {
    final result = await _favoriteDb.addFavorite(place);
    if (result) {
      await loadFavorites();
    }
    return result;
  }

  Future<bool> removeFavorite(String placeId) async {
    final result = await _favoriteDb.removeFavorite(placeId);
    if (result) {
      await loadFavorites();
    }
    return result;
  }

  Future<bool> isFavorite(String placeId) async {
    return await _favoriteDb.isFavorite(placeId);
  }

  Future<void> toggleFavorite(PlaceDetail place) async {
    final isFav = await isFavorite(place.placeId);
    if (isFav) {
      await removeFavorite(place.placeId);
    } else {
      await addFavorite(place);
    }
  }
}
