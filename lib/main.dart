import 'package:flutter/material.dart';
import 'package:meal_order/dummy_data.dart';
import './screens/filter_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/tabs_screnn.dart';
import './screens/category_meals_screen.dart';
import 'home_page.dart';
import './models/meal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetrarian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favourtMeals = [];

  void _toggleFavorite(String mealId) {
    final existingIndex = _favourtMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favourtMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favourtMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favourtMeals.any((meal) => meal.id == id);
  }

  void _setFilter(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetrarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Ralway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: '/',
      routes: {
        TabsScreen.routeName: (context) => TabsScreen(_favourtMeals),
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (context) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FilterScreen.routeName: (context) => FilterScreen(_filters, _setFilter),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => MyHomePage());
      },
    );
  }
}
