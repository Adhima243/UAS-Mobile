import 'package:flutter/material.dart';
import '../pages/splash/splash_page.dart';
import '../pages/home/home_page.dart';
import '../pages/detail/detail_page.dart';
import '../pages/search/search_page.dart';
import '../pages/favorite/favorite_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/home/location_picker_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String search = '/search';
  static const String favorite = '/favorite';
  static const String profile = '/profile';
  static const String locationPicker = '/location-picker';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    home: (context) => const HomePage(),
    detail: (context) => const DetailPage(),
    search: (context) => const SearchPage(),
    favorite: (context) => const FavoritePage(),
    profile: (context) => const ProfilePage(),
    locationPicker: (context) => const LocationPickerPage(),
  };
}
