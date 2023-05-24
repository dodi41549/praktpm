import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectakhirpraktpm/Favorit.dart';
import 'package:projectakhirpraktpm/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<dynamic> recipes = [];
  Set<int> favoriteRecipes = Set<int>();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    loadFavoriteRecipes();
  }

  Future<void> fetchRecipes() async {
    final apiUrl = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=c185558e4a9243e88d8d4f9957a18f71&cuisine=italian&number=15&addRecipeInformation=true');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      setState(() {
        recipes = json.decode(response.body)['results'];
      });
    }
  }

  Future<void> loadFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<int> favorites =
    (prefs.getStringList('favoriteRecipes') ?? []).map((id) => int.parse(id)).toSet();
    setState(() {
      favoriteRecipes = favorites;
    });
  }

  Future<void> saveFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = favoriteRecipes.map((id) => id.toString()).toList();
    await prefs.setStringList('favoriteRecipes', favorites);
  }

  bool isRecipeFavorite(int recipeId) {
    return favoriteRecipes.contains(recipeId);
  }

  void toggleRecipeFavorite(int recipeId) {
    setState(() {
      if (isRecipeFavorite(recipeId)) {
        favoriteRecipes.remove(recipeId);
      } else {
        favoriteRecipes.add(recipeId);
      }
      saveFavoriteRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 16.0),
          Text('Food Recipe'),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteRecipesScreen(favoriteRecipes: favoriteRecipes, recipes: recipes),
                ),
              );
            },
          ),
         ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/data.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            bool isFavorite = isRecipeFavorite(recipes[index]['id']);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      recipes[index]['image'],
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipes[index]['title'],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Price per Serving: \$${recipes[index]['pricePerServing']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        toggleRecipeFavorite(recipes[index]['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}