import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/category_model.dart';
import '../../../widgets/category_item.dart';
import '../../../controllers/place_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: CategoryModel.categories.length,
            itemBuilder: (context, index) {
              final category = CategoryModel.categories[index];
              final isSelected = provider.selectedCategory == category.id;
              
              return CategoryItem(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  provider.setCategory(category.id);
                },
              );
            },
          ),
        );
      },
    );
  }
}
