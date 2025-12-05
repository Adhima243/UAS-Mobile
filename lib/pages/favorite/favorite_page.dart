import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/favorite_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';
import '../../routes/app_routes.dart';
import '../../config/theme.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  IconData _getCategoryIcon(String? categories) {
    if (categories == null) return Icons.place;

    final category = categories.toLowerCase();
    if (category.contains('beach')) return Icons.beach_access;
    if (category.contains('natural')) return Icons.nature;
    if (category.contains('heritage')) return Icons.castle;
    return Icons.place;
  }

  Color _getCategoryColor(String? categories) {
    if (categories == null) return AppTheme.primaryColor;

    final category = categories.toLowerCase();
    if (category.contains('beach')) return Colors.blue;
    if (category.contains('natural')) return Colors.green;
    if (category.contains('heritage')) return Colors.brown;
    return AppTheme.primaryColor;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Memuat favorit...');
          }

          if (provider.favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'Belum ada favorit',
              subtitle: 'Tambahkan tempat wisata ke favorit',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final place = provider.favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: place.images != null && place.images!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            place.images!.first,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getCategoryColor(place.categories).withOpacity(0.7),
                                    _getCategoryColor(place.categories).withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getCategoryIcon(place.categories),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(place.categories).withOpacity(0.7),
                                _getCategoryColor(place.categories).withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getCategoryIcon(place.categories),
                            color: Colors.white,
                          ),
                        ),
                  title: Text(
                    place.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    place.address ?? 'Alamat tidak tersedia',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.accentColor),
                    onPressed: () async {
                      await provider.removeFavorite(place.placeId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dihapus dari favorit'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: place.placeId,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
