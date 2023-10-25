import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  Map<Filter, bool> _initialFilters = kInitialFilters;
  int currentScreenIndex = 0;
  List<Meal> favoriteMeals = [];

  void _showingMessageInfo(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _onSelectedLink(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final currentFilters =
          await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) {
            return FiltersScreen(
              currentFilters: _initialFilters,
            );
          },
        ),
      );
      setState(() {
        _initialFilters = currentFilters ?? kInitialFilters;
      });
    }
  }

  void _addYourFavoriteMeal(Meal meal) {
    if (favoriteMeals.contains(meal)) {
      setState(() {
        favoriteMeals.remove(meal);
      });
      _showingMessageInfo('Meal is removed from the favorites');
    } else {
      setState(() {
        favoriteMeals.add(meal);
      });
      _showingMessageInfo('Meal is added to the favorites');
    }
  }

  void changeScreenIndex(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = dummyMeals.where((meal) {
      if (_initialFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_initialFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_initialFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_initialFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onAddFavoriteMeal: _addYourFavoriteMeal,
      firstFilteredMeals: filteredMeals,
    );

    var activepageTitle = 'Categories';

    if (currentScreenIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
        onAddFavoriteMeal: _addYourFavoriteMeal,
      );
      activepageTitle = 'Your Favorite';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activepageTitle),
      ),
      drawer: MainDrawer(
        selectedLink: _onSelectedLink,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        currentIndex: currentScreenIndex,
        onTap: changeScreenIndex,
      ),
    );
  }
}
