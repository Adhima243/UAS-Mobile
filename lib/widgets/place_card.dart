import 'package:flutter/material.dart';
import '../models/place.dart';
import '../utils/formatter.dart';
import '../config/theme.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
  });

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
    if (category.contains('religion')) return Icons.temple_buddhist;

    return Icons.place;
  }

  Color _getCategoryColor(String? categories) {
    if (categories == null) return AppTheme.primaryColor;

    final category = categories.toLowerCase();

    if (category.contains('beach')) return Colors.blue;
    if (category.contains('natural')) return Colors.green;
    if (category.contains('heritage')) return Colors.brown;
    if (category.contains('entertainment')) return Colors.purple;
    if (category.contains('park')) return Colors.teal;

    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final categoryIcon = _getCategoryIcon(place.categories);
    final categoryColor = _getCategoryColor(place.categories);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon dengan gradient background
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor.withOpacity(0.7),
                      categoryColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (place.address != null)
                      Text(
                        place.address!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (place.distance != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: categoryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatter.formatDistance(place.distance!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: categoryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
