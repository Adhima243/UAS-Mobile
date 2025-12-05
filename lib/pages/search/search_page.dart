import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/search_provider.dart';
import '../../widgets/place_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../routes/app_routes.dart';
import '../../config/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear search when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      print('Performing search for: $query');
      context.read<SearchProvider>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Cari tempat wisata...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _performSearch(),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<SearchProvider>().clearSearch();
              },
            ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          if (provider.isSearching) {
            return const LoadingWidget(message: 'Mencari...');
          }

          if (provider.error != null) {
            return ErrorState(
              message: provider.error!,
              onRetry: () => provider.search(provider.query),
            );
          }

          if (provider.query.isEmpty) {
            return const EmptyState(
              icon: Icons.search,
              title: 'Mulai Pencarian',
              subtitle: 'Ketik nama tempat wisata yang ingin dicari',
            );
          }

          if (provider.searchResults.isEmpty) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Tidak ditemukan',
              subtitle: 'Coba kata kunci lain',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final place = provider.searchResults[index];
              return PlaceCard(
                place: place,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detail,
                    arguments: place.placeId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
