import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final IconData icon;

  const CategoryItem({required this.title, required this.icon});
}

class CategoriesWidgets extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String>? onSelectCategory;

  const CategoriesWidgets({
    super.key,
    this.selectedCategory = 'Semua',
    this.onSelectCategory,
  });

  static const Color primaryColor = Color(0xFF475569);
  static const Color accentColor = Color(0xFF7DD3FC);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);

  static const List<CategoryItem> _categoryList = [
    CategoryItem(title: 'Semua', icon: Icons.grid_view_rounded),
    CategoryItem(title: 'Smartphone', icon: Icons.smartphone_rounded),
    CategoryItem(title: 'Laptop', icon: Icons.laptop_mac_rounded),
    CategoryItem(title: 'Audio', icon: Icons.headphones_rounded),
    CategoryItem(title: 'Aksesoris', icon: Icons.devices_other_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categoryList.map((category) {
          final isSelected = selectedCategory == category.title;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (onSelectCategory != null) {
                    onSelectCategory!(category.title);
                  }
                },
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [primaryColor, Color(0xFF64748B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? primaryColor : borderColor,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.15)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.icon,
                          size: 14,
                          color: isSelected ? accentColor : primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12.8,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected ? Colors.white : textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
