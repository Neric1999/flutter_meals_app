import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoritesMealNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealNotifier() : super([]);

  void toggleFavoritesMealStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state
          .where(
            (mItem) => mItem.id != meal.id,
          )
          .toList();
    } else {
      state = [...state, meal];
    }
  }
}
