import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/detail_provider.dart';
import '../../controllers/favorite_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_state.dart';
import '../../config/theme.dart';
import '../../utils/formatter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;

  IconData _getCategoryIcon(String? categories) {
    if (categories == null) return Icons.place;
    
    final category = categories.toLowerCase();
    
    if (category.contains('beach')) return Icons.beach_access;
    if (category.contains('tourism.sights')) return Icons.landscape;
    if (category.contains('tourism.attraction')) return Icons.attractions;
    if (category.contains('natural')) return Icons.nature;
    if (category.contains('heritage')) return Icons.castle;
    if (category.contains('entertainment')) return Icons.celebration;
    if (category.contains('park')) return Icons.park;
    
    return Icons.place;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final placeId = ModalRoute.of(context)!.settings.arguments as String;
    
    Future.microtask(() async {
      await context.read<DetailProvider>().loadPlaceDetail(placeId);
      _checkFavorite(placeId);
    });
  }

  Future<void> _checkFavorite(String placeId) async {
    final isFav = await context.read<FavoriteProvider>().isFavorite(placeId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Memuat detail...');
          }

          if (provider.error != null) {
            return ErrorState(
              message: provider.error!,
              onRetry: () {
                final placeId = ModalRoute.of(context)!.settings.arguments as String;
                provider.loadPlaceDetail(placeId);
              },
            );
          }

          final place = provider.placeDetail;
          if (place == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    place.name,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  background: place.images != null && place.images!.isNotEmpty
                      ? Image.network(
                          place.images!.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryColor,
                                  AppTheme.secondaryColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              _getCategoryIcon(place.categories),
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.secondaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            _getCategoryIcon(place.categories),
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () async {
                      await context.read<FavoriteProvider>().toggleFavorite(place);
                      _checkFavorite(place.placeId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite 
                                ? 'Dihapus dari favorit' 
                                : 'Ditambahkan ke favorit',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (place.address != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.address!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (place.phone != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.phone, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              place.phone!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (place.website != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.language, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.website!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (place.categories != null) ...[
                        Text(
                          'Kategori',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: place.categories!.split(',').take(5).map((cat) {
                            return Chip(
                              label: Text(
                                Formatter.formatCategory(cat.trim()),
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text(
                        'Deskripsi',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        place.description ?? 
                        'Tidak ada deskripsi tersedia untuk tempat ini.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                      if (place.website != null) ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Bisa tambahkan webview atau url launcher
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur buka website dalam pengembangan'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Buka Website'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              side: const BorderSide(color: AppTheme.primaryColor),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
