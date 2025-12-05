import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place_detail.dart';

class FavoriteDb {
  static const String _key = 'favorites';

  Future<List<PlaceDetail>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_key);
      
      if (favoritesJson == null) return [];
      
      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.map((json) => PlaceDetail.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addFavorite(PlaceDetail place) async {
    try {
      final favorites = await getFavorites();
      
      // Check if already exists
      if (favorites.any((p) => p.placeId == place.placeId)) {
        return false;
      }
      
      favorites.add(place);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(String placeId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((p) => p.placeId == placeId);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isFavorite(String placeId) async {
    final favorites = await getFavorites();
    return favorites.any((p) => p.placeId == placeId);
  }

  Future<bool> _saveFavorites(List<PlaceDetail> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        favorites.map((p) => p.toJson()).toList(),
      );
      return await prefs.setString(_key, encoded);
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_key);
    } catch (e) {
      return false;
    }
  }
}
