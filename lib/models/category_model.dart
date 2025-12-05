import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  // Kategori sesuai Geoapify API
  static List<CategoryModel> categories = [
    CategoryModel(id: '', name: 'Semua', icon: Icons.apps),
    CategoryModel(id: 'tourism', name: 'Wisata', icon: Icons.tour),
    CategoryModel(id: 'tourism.sights', name: 'Pemandangan', icon: Icons.landscape),
    CategoryModel(id: 'tourism.attraction', name: 'Atraksi', icon: Icons.attractions),
    CategoryModel(id: 'tourism.information', name: 'Info Wisata', icon: Icons.info),
    CategoryModel(id: 'natural', name: 'Alam', icon: Icons.nature),
    CategoryModel(id: 'beach', name: 'Pantai', icon: Icons.beach_access),
    CategoryModel(id: 'entertainment', name: 'Hiburan', icon: Icons.celebration),
    CategoryModel(id: 'heritage', name: 'Heritage', icon: Icons.castle),
    CategoryModel(id: 'national_park', name: 'Taman', icon: Icons.park),
  ];
}
