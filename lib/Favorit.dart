import 'package:flutter/material.dart';
import 'package:projectakhirpraktpm/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  final Set<int> favoriteRecipes;
  final List<dynamic> recipes;

  FavoriteRecipesScreen({required this.favoriteRecipes, required this.recipes});

  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  Set<int> favoriteRecipes = Set<int>();

  @override
  void initState() {
    super.initState();
    favoriteRecipes = widget.favoriteRecipes;
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

  Future<void> saveFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = favoriteRecipes.map((id) => id.toString()).toList();
    await prefs.setStringList('favoriteRecipes', favorites);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> favoriteRecipeList = [];

    // Filter resep favorit berdasarkan daftar resep yang diunduh sebelumnya
    for (var recipe in widget.recipes) {
      if (favoriteRecipes.contains(recipe['id'])) {
        favoriteRecipeList.add(recipe);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/data.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: favoriteRecipeList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: favoriteRecipeList[index]),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      favoriteRecipeList[index]['image'],
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
                            favoriteRecipeList[index]['title'],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Price per Serving: \$${favoriteRecipeList[index]['pricePerServing']}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isRecipeFavorite(favoriteRecipeList[index]['id'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isRecipeFavorite(favoriteRecipeList[index]['id'])
                            ? Colors.red
                            : null,
                      ),
                      onPressed: () {
                        toggleRecipeFavorite(favoriteRecipeList[index]['id']);
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
