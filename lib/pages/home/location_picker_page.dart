import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/place_provider.dart';
import '../../config/theme.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  final List<Map<String, dynamic>> _popularCities = [
    {'name': 'Yogyakarta', 'lat': -7.7956, 'lon': 110.3695},
    {'name': 'Jakarta', 'lat': -6.2088, 'lon': 106.8456},
    {'name': 'Bali (Denpasar)', 'lat': -8.6705, 'lon': 115.2126},
    {'name': 'Bandung', 'lat': -6.9175, 'lon': 107.6191},
    {'name': 'Surabaya', 'lat': -7.2575, 'lon': 112.7521},
    {'name': 'Malang', 'lat': -7.9666, 'lon': 112.6326},
    {'name': 'Semarang', 'lat': -6.9932, 'lon': 110.4203},
    {'name': 'Medan', 'lat': 3.5952, 'lon': 98.6722},
    {'name': 'Makassar', 'lat': -5.1477, 'lon': 119.4327},
    {'name': 'Lombok', 'lat': -8.6529, 'lon': 116.3247},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kota Populer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularCities.length,
              itemBuilder: (context, index) {
                final city = _popularCities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.location_city, color: AppTheme.primaryColor),
                    title: Text(city['name']),
                    subtitle: Text('Lat: ${city['lat']}, Lon: ${city['lon']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.read<PlaceProvider>().updateLocation(
                        city['lat'],
                        city['lon'],
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Koordinat Manual',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _latController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'Contoh: -7.7956',
                prefixIcon: Icon(Icons.my_location),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lonController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'Contoh: 110.3695',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final lat = double.tryParse(_latController.text);
                  final lon = double.tryParse(_lonController.text);

                  if (lat != null && lon != null) {
                    context.read<PlaceProvider>().updateLocation(lat, lon);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Masukkan koordinat yang valid'),
                        backgroundColor: AppTheme.accentColor,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Terapkan Lokasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }
}
