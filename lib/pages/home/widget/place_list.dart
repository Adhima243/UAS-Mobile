import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/place_provider.dart';
import '../../../widgets/place_card.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../routes/app_routes.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const LoadingWidget(message: 'Memuat tempat wisata...');
        }

        if (provider.error != null) {
          return ErrorState(
            message: provider.error!,
            onRetry: () => provider.loadPlaces(),
          );
        }

        if (provider.places.isEmpty) {
          return const EmptyState(
            icon: Icons.place_outlined,
            title: 'Tidak ada tempat wisata',
            subtitle: 'Coba ubah lokasi atau kategori',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: provider.places.length,
          itemBuilder: (context, index) {
            final place = provider.places[index];
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
    );
  }
}
